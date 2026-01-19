using CSV, DataFrames, Dates

# -----------------------------------------
# CONFIG (NO const)
# -----------------------------------------
CSV_FILE     = cd_path * "BalPopo/registrations.csv"
LEDGER_FILE  = cd_path * "BalPopo/sent_codes.csv"   # simple CSV, no header
BASE_URL     = "https://balpol.rma.ac.be/registration/confirmation"
MAIL_FROM    = "noreply@177pol.rma.ac.be"
MAIL_SUBJECT = "Ball Popo 177 — Registration confirmation"

mkpath(dirname(CSV_FILE))
mkpath(dirname(LEDGER_FILE))

# -----------------------------------------
# DECRYPT
# -----------------------------------------
function xor_decrypt_base64(enc::AbstractString, key::UInt8 = 0xB1)
    s   = replace(enc, "-" => "+", "_" => "/")
    pad = mod(4 - (length(s) % 4), 4)
    s  *= repeat("=", pad)
    raw = base64decode(s)
    bytes = UInt8[(b ⊻ key) for b in raw]
    return String(bytes)
end

# -----------------------------------------
# SIMPLE LEDGER USING CSV (NO HEADER)
# -----------------------------------------
function load_ledger(path::AbstractString)
    if !isfile(path)
        return Set{String}()
    end
    lines = readlines(path)
    return Set(strip.(lines))
end

function add_to_ledger(path::AbstractString, code::String)
    open(path, "a") do io
        write(io, code * "\n")
    end
end

# -----------------------------------------
# EMAIL BODY
# -----------------------------------------
function make_body(sal, fname, lname, rawcode)
    who = strip(join(filter(!isempty, [sal, fname, lname]), " "))
    who = isempty(who) ? "guest" : who
    return """
Dear $(who),

Please find your registration confirmation and entry ticket in the following link.
$(BASE_URL)/$(rawcode)

Kusies,
Julia
"""
end

# -----------------------------------------
# MAIL SENDER
# -----------------------------------------

function send_mail(; from::String, to::String, subject::String, body::String)
    run(pipeline(`mail -a "From: $from" -s $subject $to`, stdin = IOBuffer(body)))
end

# -----------------------------------------
# PROCESS ONE CYCLE
# -----------------------------------------
function process_once()

    if !isfile(CSV_FILE)
        @warn "CSV file not found yet, waiting…" CSV_FILE
        return (0, 0, 0)
    end

    df = CSV.read(CSV_FILE, DataFrame)

    required = ["Raw entry code", "Encrypted email address", "Salutation",
                "First name", "Last name"]

    for col in required
        if !(col in names(df))
            @warn "Column missing" col
            return (nrow(df), 0, nrow(df))
        end
    end

    sent = load_ledger(LEDGER_FILE)

    sent_now = 0
    skipped  = 0

    for row in eachrow(df[1:min(4, nrow(df)), :]) #for row in eachrow(df)

        rawcode = strip(string(row["Raw entry code"]))
        if isempty(rawcode) || (rawcode in sent)
            continue
        end

        enc_email = strip(string(row["Encrypted email address"]))

        email = try
            xor_decrypt_base64(enc_email)
        catch
            ""
        end

        if isempty(email)
            @warn "Invalid email decrypt; skipping" rawcode enc_email
            skipped += 1
            continue
        end

        sal   = strip(string(row["Salutation"]))
        fname = strip(string(row["First name"]))
        lname = strip(string(row["Last name"]))
        body  = make_body(sal, fname, lname, rawcode)

        try
            send_mail(from=MAIL_FROM, to=email, subject=MAIL_SUBJECT, body=body)
            println("[$(Dates.format(now(), "yyyy-mm-dd HH:MM:SS"))] SENT to $(email) | code=$(rawcode)")

            push!(sent, rawcode)
            add_to_ledger(LEDGER_FILE, rawcode)

            sent_now += 1
        catch e
            @warn "Send failed; will retry next cycle" error=string(e) code=rawcode email=email body=body
            skipped += 1
        end
    end

    return (nrow(df), sent_now, skipped)
end

# -----------------------------------------
# MAIN LOOP (EVERY 5 MIN)
# -----------------------------------------
println("send_confirmations.jl starting…")
println("CSV_FILE=$(CSV_FILE)")
println("LEDGER_FILE=$(LEDGER_FILE)")

@async while true
    t0 = now()
    total, sent_now, skipped = process_once()
    println("[$(Dates.format(t0, "yyyy-mm-dd HH:MM:SS"))] cycle: total=$(total), sent=$(sent_now), skipped=$(skipped)")
    sleep(300)
end