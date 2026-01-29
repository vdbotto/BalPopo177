using CSV, DataFrames, Dates

cd_path = "/root/BalPopo177-main/"

# -----------------------------------------
# CONFIG (NO const)
# -----------------------------------------
# CSV_FILE    = cd_path * "BalPopo/registrations.csv"       # master registrations
CODES_FILE  = cd_path * "BalPopo/codes_to_send.csv"       # one raw code per line
BASE_URL    = "https://balpol.rma.ac.be/registration/confirmation"
MAIL_FROM   = "noreply@177pol.rma.ac.be"
MAIL_SUBJECT = "Ball Popo 177 — Registration confirmation"
REPORT_TO   = "otto_vandenbergh@icloud.com"

# -----------------------------------------
# DECRYPT (same XOR scheme as before)
# -----------------------------------------
function xor_decrypt_base64(enc::AbstractString, key::UInt8 = 0xB1)  # 0xB1 == 177
    s   = replace(enc, "-" => "+", "_" => "/")
    pad = mod(4 - (length(s) % 4), 4)
    s  *= repeat("=", pad)
    raw = base64decode(s)
    bytes = UInt8[(b ⊻ key) for b in raw]
    return String(bytes)
end

# -----------------------------------------
# EMAIL BODY (simple + link to confirmation)
# -----------------------------------------
function make_body(sal, fname, lname, rawcode)
    who = strip(join(filter(!isempty, [sal, fname, lname]), " "))
    who = isempty(who) ? "guest" : who
    return """
Dear $(who),

Please find your registration confirmation and entry ticket at:
$(BASE_URL)/$(rawcode)

Kind regards,
Ball Popo 177 Team
"""
end

# -----------------------------------------
# MAIL SENDER (uses local `mail`)
# -----------------------------------------
function send_mail(; from::String, to::String, subject::String, body::String)
    run(pipeline(`mail -a "From: $from" -s $subject $to`, stdin = IOBuffer(body)))
end

# -----------------------------------------
# HELPERS
# -----------------------------------------
# Find first existing column name among aliases
find_col = function(df::DataFrame, aliases::Vector{String})
    for a in aliases
        if a in names(df)
            return a
        end
    end
    return nothing
end

# Try to parse a timestamp; fallback to now() if not parseable
# Try to parse a timestamp from various inputs, return minimal value on failure
function parse_ts(s)::DateTime
    if s === missing
        return DateTime(0)
    elseif s isa DateTime
        return s
    else
        x = String(s)
        # common formats we expect
        for fmt in (dateformat"yyyy-mm-ddTHH:MM:SS",
                    dateformat"yyyy-mm-dd HH:MM:SS",
                    dateformat"yyyy/mm/dd HH:MM:SS",
                    dateformat"dd/mm/yyyy HH:MM:SS")
            try
                return DateTime(x, fmt)
            catch
            end
        end
        try
            return DateTime(x)  # fallback: ISO / default parser
        catch
            return DateTime(0)  # minimal so the "latest" logic still works
        end
    end
end

# Read codes file: one code per line, ignore blanks and an optional "raw" header
function read_codes_list(path::AbstractString)
    if !isfile(path)
        error("Codes file not found: " * path)
    end
    lines = strip.(readlines(path))
    codes = String[]
    seen = Set{String}()
    for ln in lines
        if isempty(ln)
            continue
        end
        # if someone pasted a CSV accidentally, take first field
        code = first(split(ln, ',')) |> strip
        if lowercase(code) == "raw" || isempty(code)
            continue
        end
        if !(code in seen)
            push!(codes, code); push!(seen, code)
        end
    end
    return codes
end

# Lookup most recent registration row for a raw code
function latest_row_for_code(df::DataFrame, code::String; code_col::String, ts_col::Union{Nothing,String})
    idxs = findall(x -> !ismissing(x) && String(x) == code, df[!, code_col])
    if isempty(idxs)
        return nothing
    end
    if ts_col === nothing
        return df[idxs[end], :] # last occurrence if no timestamp
    else
        # pick the row with max timestamp
        best_idx = idxs[1]
        best_ts  = parse_ts(df[best_idx, ts_col])
        for i in Iterators.drop(idxs, 1)
            tsi = parse_ts(df[i, ts_col])
            if tsi > best_ts
                best_ts = tsi
                best_idx = i
            end
        end
        return df[best_idx, :]
    end
end

# -----------------------------------------
# MAIN (single run)
# -----------------------------------------
function main()
    println("== Send confirmations (single run) ==")
    println("CSV_FILE    = $(CSV_FILE)")
    println("CODES_FILE  = $(CODES_FILE)")
    println("Started at  = $(Dates.format(now(), "yyyy-mm-dd HH:MM:SS"))")
    println()

    # Load master registrations
    if !isfile(CSV_FILE)
        error("Registrations CSV not found: " * CSV_FILE)
    end
    df = CSV.read(CSV_FILE, DataFrame)

    # Robust header detection
    code_col = find_col(df, ["Raw entry code","uniqueCode","code","entry_code"])
    email_col = find_col(df, ["Encrypted email address","email","Email","Email address"])
    sal_col   = find_col(df, ["Salutation","salutation","Title"])
    fn_col    = find_col(df, ["First name","First Name","firstName","firstname"])
    ln_col    = find_col(df, ["Last name","Last Name","lastName","lastname","surname"])
    ts_col    = find_col(df, ["timestamp","Timestamp","created_at","Created","Date"])

    if code_col === nothing
        error("Code column not found (tried: Raw entry code / uniqueCode / code / entry_code)")
    end
    if email_col === nothing
        error("Email column not found (tried: Encrypted email address / email / Email)")
    end

    codes = read_codes_list(CODES_FILE)
    println("Loaded $(length(codes)) codes to process.")
    println()

    sent_list   = Vector{Tuple{String,String}}()     # (code, email)
    fail_list   = Vector{Tuple{String,String}}()     # (code, reason)
    notfound    = String[]

    for code in codes
        row = latest_row_for_code(df, code; code_col=code_col, ts_col=ts_col)
        if row === nothing
            push!(notfound, code)
            println("NOT FOUND  | $(code)")
            continue
        end

        # Extract fields (with defaults)
        sal   = sal_col === nothing ? "" : (row[sal_col] === missing ? "" : String(row[sal_col]))
        fname = fn_col  === nothing ? "" : (row[fn_col]  === missing ? "" : String(row[fn_col]))
        lname = ln_col  === nothing ? "" : (row[ln_col]  === missing ? "" : String(row[ln_col]))

        enc_email = row[email_col]
        email = ""
        try
            email = xor_decrypt_base64(String(enc_email))
        catch
            email = String(enc_email)  # if it's already plain
        end
        email = strip(email)

        if isempty(email)
            reason = "empty or invalid email"
            push!(fail_list, (code, reason))
            println("SKIPPED    | $(code) | reason=$(reason)")
            continue
        end

        body = make_body(sal, fname, lname, code)

        try
            send_mail(from=MAIL_FROM, to=email, subject=MAIL_SUBJECT, body=body)
            push!(sent_list, (code, email))
            println("SENT       | $(code) -> $(email)")
        catch e
            reason = "send failed: $(e)"
            push!(fail_list, (code, reason))
            println("FAILED     | $(code) | $(reason)")
        end
    end

    # Build report
    tnow = Dates.format(now(), "yyyy-mm-dd HH:MM:SS")
    report = IOBuffer()
    println(report, "Ball Popo 177 — Confirmation Send Report")
    println(report, "Run at: $tnow")
    println(report, "Source registrations: $CSV_FILE")
    println(report, "Codes file: $CODES_FILE")
    println(report, "")
    println(report, "Summary")
    println(report, "-------")
    println(report, "Requested: $(length(codes))")
    println(report, "Sent     : $(length(sent_list))")
    println(report, "Failed   : $(length(fail_list))")
    println(report, "Not found: $(length(notfound))")
    println(report, "")
    if !isempty(sent_list)
        println(report, "Sent")
        println(report, "----")
        for (code,email) in sent_list
            println(report, "$(code) -> $(email)")
        end
        println(report, "")
    end
    if !isempty(fail_list)
        println(report, "Failed")
        println(report, "------")
        for (code,reason) in fail_list
            println(report, "$(code) | $(reason)")
        end
        println(report, "")
    end
    if !isempty(notfound)
        println(report, "Not found")
        println(report, "---------")
        for code in notfound
            println(report, code)
        end
        println(report, "")
    end

    report_body = String(take!(report))

    # Send report
    try
        send_mail(from=MAIL_FROM, to=REPORT_TO, subject="Ball Popo 177 — Confirmation send report", body=report_body)
        println("\nReport sent to $(REPORT_TO).")
    catch e
        println("\nReport sending failed: $(e)")
        println("\n--- Report content ---\n" * report_body)
    end

    println("\nDone.")
end

# Run once
main()
