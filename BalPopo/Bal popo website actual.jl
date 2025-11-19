# Functie om logo of achtergrondafbeelding als base64 in te laden
function logo_base64_data(path)
    img = load(path)
    buf = IOBuffer()
    ImageMagick.save(Stream(format"PNG", buf), img)
    data = base64encode(take!(buf))
    close(buf)
    return data
end
#Crookerijen

function background_base64_data(path)
    img = load(path)
    buf = IOBuffer()
    ImageMagick.save(Stream(format"JPG", buf), img)
    data = base64encode(take!(buf))
    close(buf)
    return data
end



function create_long_background(path; repetitions)
    img = load(path)
    stacked = img
    for i in 2:repetitions
        part = (i % 2 == 0) ? reverse(img, dims=1) : img  # Flip vertically every second image
        stacked = vcat(stacked, part)                     # Stack vertically
    end
    buf = IOBuffer()
    ImageMagick.save(Stream(format"JPG", buf), stacked)
    data = base64encode(take!(buf))
    close(buf)
  return data
end



function layout(title, content; background_css = "")
  favico = logo_base64_data("BalPopo/static/logo_dark.png")

  event_jsonld = raw"""
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Event",
    "name": "Bal Popo 177",
    "startDate": "2025-02-13T18:00",
    "endDate": "2025-02-13T23:59",
    "eventAttendanceMode": "https://schema.org/OfflineEventAttendanceMode",
    "eventStatus": "https://schema.org/EventScheduled",
    "location": {
      "@type": "Place",
      "name": "La Fabbrica",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "Avenue du Port 86C BT5",
        "addressLocality": "Brussel",
        "postalCode": "1000",
        "addressCountry": "BE"
      }
    },
    "image": [
      "https://jouw-ngrok-link.ngrok.io/static/POL_logo.png"
    ],
    "description": "The yearly ball of the RMA's polytechnic faculty.",
    "offers": {
      "@type": "Offer",
      "url": "https://jouw-ngrok-link.ngrok.io/Registration",
      "price": "0",
      "priceCurrency": "EUR",
      "availability": "https://schema.org/InStock",
      "validFrom": "2024-12-01T12:00"
    },
    "organizer": {
      "@type": "Organization",
      "name": "Ball Polytechnic",
      "url": "https://jouw-ngrok-link.ngrok.io"
    }
  }
  </script>
  """
  banner = logo_base64_data("BalPopo/static/couverture_facebook-removebg.png")
  bg = create_long_background("BalPopo/static/orange_black.png", repetitions=20)



  html("""
    <!DOCTYPE html>
    <html lang="nl">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>$("Ball Popo 177 | "*title)</title>
        $event_jsonld
        <link rel="icon" type="image/jpeg" href="data:image/jpeg;base64,$favico" />

        <link
          href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap"
          rel="stylesheet"
        />

        <style>
            * { box-sizing: border-box; margin: 0; padding: 0; }
            body {
                font-family: "Poppins", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, sans-serif;


                color: #f1f1f1;
                line-height: 1.6;
                background-image: url("data:image/png;base64,$bg");              
                background-size: cover;
                background-position: center top;
                background-repeat: no-repeat;

                margin: 0;
                padding: 0;  
                display: flex;
                flex-direction: column;
                min-height: 100vh;  
            }

            html, body {
              height: 100%;
              margin: 0;
            }

            main {
              flex: 1;
              padding: 20px 40px;
            }
            
            header {
                background-color: #transparent;
                padding: 20px 40px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
                
            header img:hover {
            opacity: 0.85;
            transform: scale(1.02);
            transition: all 0.2s ease;
            }

            header h1 { color: #FFA500; font-size: 1.8rem; }

            nav { display: flex; gap: 30px; }
            nav a {
                color: white;
                text-decoration: none;
                font-weight: bold;
                font-size: 1.1rem;
                transition: color 0.2s;
            }
            nav a:hover { color: #FFA500; transform: scale(1.08); }


            .hero h2 { font-size: 3em; margin-bottom: 10px; }
            .hero p { font-size: 1.3em; color: #ccc; }

            h1,h2,h3 { color: #FFA500; }
            p { color: #eee; }
            footer {
                background-color: #111;
                color: #ccc;
                text-align: center;
                padding: 20px;
                font-size: 0.9em;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 12px;
                flex-wrap: wrap;
            }
            footer a {
                color: #ccc;
                margin: 0 10px;
                text-decoration: none;
            }
            footer a:hover {
                color: #fff;
                text-decoration: underline;
            }

            footer img {
              height: 20px; /* match text height */
              vertical-align: middle;
            }

            video#eventvideo {
                width: 100%;
                margin-top: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(255,165,0,0.2);
            }
                /* Base styles */
                /* Desktop */

            .nav-links {
              display: flex;
              gap: 20px;
            }

            .hamburger, .mobile-menu {
              display: none;
            }
            .close-btn {
              font-size: 28px;
              color: #FFFFFF;
              cursor: pointer;
              margin-bottom: 20px;
              text-align: right;
            }

            /* Mobile */
            @media (max-width: 768px) {
              main {
                  padding: 16px; /* Mobile-friendly */
                }

              .nav-links {
                display: none; /* Hide desktop nav */
              }
              .hamburger {
                display: block;
                font-size: 28px;
                cursor: pointer;
                margin-left: auto;
              }
              .mobile-menu {
                display: none;
                flex-direction: column;
                background: #000;
                padding: 20px;
              }

              .mobile-menu {
                display: flex;
                flex-direction: column;
                background: rgba(0, 0, 0, 0.95);
                position: fixed;
                top: 0;
                right: 0;
                width: 70%; /* or 100% for full screen */
                height: 100%;
                padding: 40px 20px;
                transform: translateX(100%);
                transition: transform 0.3s ease-in-out;
                z-index: 1000;
              }

              .mobile-menu.show {
                transform: translateX(0);
              }

              .mobile-menu a {
                color: #fff;
                font-size: 1.2rem;
                margin-bottom: 20px;
                text-decoration: none;
              }
            }
        </style>
        <script>
            const origTitle = document.title;
            document.addEventListener("visibilitychange", () => {
              document.title = document.hidden ? "Hey, come back!" : origTitle;
            });

            function toggleMenu() {
              const menu = document.querySelector('.mobile-menu');
              const hamburger = document.querySelector('.hamburger');
              menu.classList.toggle('show');
              hamburger.textContent = menu.classList.contains('show') ? '✖' : '☰';
            }


        </script>
    </head>
    <body>

        <header>
          <a href="/" style="display: inline-block;">
            <img src="data:image/png;base64,$banner" alt="Ball Popo 177" style="height:80px; cursor:pointer;">
          </a>

          <!-- Desktop Navigation -->
          <nav class="nav-links">
            <a href="/">Home</a>
            <a href="/sponsors">Sponsors</a>
            <a href="/Registration">Registration</a>
            <a href="/theevent">The Event</a>
            <a href="/ourstory">Our Story</a>
          </nav>


          <div class="hamburger" onclick="toggleMenu()">☰</div>

          <nav class="mobile-menu">
            <div class="close-btn" onclick="toggleMenu()">✖</div>
            <a href="/">Home</a>
            <a href="/sponsors">Sponsors</a>
            <a href="/Registration">Registration</a>
            <a href="/theevent">The Event</a>
            <a href="/ourstory">Our Story</a>
          </nav>

        </header>


        <main>
        $content
        </main>


        <footer>
          <img src="data:image/png;base64,$(logo_base64_data("BalPopo/static/logo_white.png"))" alt="Logo">
          <span>Ball Popo 177 —</span>
          <a href="/legal">Legal</a> |
          <a href="/contact">Contact</a> |
          <a href="https://julialang.org">Julia</a> |
          <a href="/Privacy policy">Privacy policy</a> |
          <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Complaints</a>
        </footer>


    </body>
    </html>
  """) 
end

# minimal HTML-escape helper
function escape_html(s)
  return replace(string(s), "&"=>"&amp;", "<"=>"&lt;", ">"=>"&gt;", "\""=>"&quot;","'"=>"&#39;")
end

# --- Helper: XOR-based reversible encoding (key = 16797) ---
function xor_encrypt_base64(s::AbstractString, key::UInt8 = UInt8(16797))
  bytes = collect(codeunits(s))
  xored = UInt8[(b ⊻ key) for b in bytes]
  b64 = base64encode(xored)
  b64_safe = replace(b64, "+" => "-", "/" => "_")
  b64_safe = replace(b64_safe, "=" => "")
  return b64_safe
end

function xor_decrypt_base64(enc::AbstractString, key::UInt8 = UInt8(16797))
  s = replace(enc, "-" => "+", "_" => "/")
  pad = mod(4 - (length(s) % 4), 4)
  s = s * repeat("=", pad)
  raw = base64decode(s)
  bytes = UInt8[(b ⊻ key) for b in raw]
  return String(bytes)
end

const CSV_FILE = "BalPopo/registrations.csv"  # stored in the same folder as your app

# Ensure CSV file has headers if it doesn't exist yet
if !isfile(CSV_FILE)
    df = DataFrame(
        timestamp = String[],
        participantType = String[],
        salutation = String[],
        firstName = String[],
        lastName = String[],
        email = String[],
        phone = String[],
        package = String[],
        faculty = String[],
        promotion = String[],
        plusOne = String[],
        PlusOnefirstName = String[],
        PlusOnelastName = String[]
    )
    CSV.write(CSV_FILE, df)
end

route("/Registration", method = POST) do
  try
      data = params()
      safe_get = key -> begin
          v = get(data, Symbol(key), nothing)
          v === nothing ? "" : String(v)
      end

      # ------ compute package/price info ------
      pkg_raw = strip(safe_get("package"))
      pkg_raw_lower = lowercase(pkg_raw)
      plus_raw = lowercase(strip(safe_get("plusOne")))
      has_dinner = occursin("dinner", pkg_raw_lower)
      has_plusone = plus_raw in ("plusone", "plus one", "plus_one", "plus one ")
      amount_eur = has_dinner ? (has_plusone ? 354 : 177) : (has_plusone ? 200 : 100)

      # ------ payment reference ------
      fname_raw = strip(safe_get("firstName"))
      fname_sanit = lowercase(replace(fname_raw, r"[^A-Za-z0-9]+" => ""))
      sec_tag = Dates.format(Dates.now(), "SS")
      payment_ref = isempty(fname_sanit) ? ("BP" * Dates.format(Dates.now(), "yyyymmddHHMMSS")) : (fname_sanit * sec_tag)

      # ------ prepare fields for encryption ------
      first = strip(safe_get("firstName"))
      last  = strip(safe_get("lastName"))
      fullname = strip(first * " " * last)

      plus_first = strip(safe_get("PlusOnefirstName"))
      plus_last  = strip(safe_get("PlusOnelastName"))
      plus_full = isempty(plus_first) && isempty(plus_last) ? "" : strip(plus_first * " " * plus_last)

      selected_formula = pkg_raw

      payload = string(fullname, "||", plus_full, "||", selected_formula)
      unique_code = xor_encrypt_base64(payload, UInt8(177))

      enc_email = try xor_encrypt_base64(safe_get("email"), UInt8(177)) catch e; safe_get("email") end
      enc_phone = try xor_encrypt_base64(safe_get("phone"), UInt8(177)) catch e; safe_get("phone") end
      enc_promotion = try xor_encrypt_base64(safe_get("promotion"), UInt8(177)) catch e; safe_get("promotion") end

      new_row = DataFrame(
          timestamp = [string(Dates.now())],
          participantType = [safe_get("participantType")],
          salutation = [safe_get("salutation")],
          firstName = [safe_get("firstName")],
          lastName = [safe_get("lastName")],
          email = [enc_email],
          phone = [enc_phone],
          package = [safe_get("package")],
          faculty = [safe_get("faculty")],
          promotion = [enc_promotion],
          plusOne = [safe_get("plusOne")],
          PlusOnefirstName = [safe_get("PlusOnefirstName")],
          PlusOnelastName = [safe_get("PlusOnelastName")],
          paymentRef = [payment_ref],
          paid = ["false"],
          amount = [string(amount_eur)],
          uniqueCode = [unique_code]
      )
      CSV.write(CSV_FILE, new_row; append=true)

      # ------ Generate Entry QR ------
      qr_b64 = ""
      try
          tmp_png = tempname() * ".png"
          exportqrcode(unique_code, tmp_png)
          img_bytes = read(tmp_png)
          qr_b64 = base64encode(img_bytes)
          try rm(tmp_png) catch end
      catch e
          qr_b64 = ""
      end

      # ------ Generate Payment QR (EPC SEPA SCT with hack) ------
      IBAN = "BE16 0020 0663 6774"
      account_name  = "KMS Promotie 177 POL FV"  # hack: force ref into name
      bic = "GEBABEBB"   # replace with your BIC
      epc_payload = join([
          "BCD","001","1","SCT",
          bic,
          account_name,
          replace(IBAN, " " => ""),
          "EUR" * @sprintf("%.2f", amount_eur),
          "",
          payment_ref
      ], "\n")

      pay_qr_b64 = ""
      try
          tmp_png2 = tempname() * ".png"
          exportqrcode(epc_payload, tmp_png2)
          img_bytes2 = read(tmp_png2)
          pay_qr_b64 = base64encode(img_bytes2)
          try rm(tmp_png2) catch end
      catch e
          pay_qr_b64 = ""
      end

      # ------ Load logo for entry QR overlay ------
      logo_path  = "BalPopo/static/logo_dark.png"
      logo_b64 = logo_base64_data(logo_path)

      # ------ Build HTML for entry QR (hidden behind button) ------
      entry_qr_inner = """
      <div style="display:flex; justify-content:center; align-items:center;">
          <div style="position:relative; line-height:0; max-width:300px; width:100%;">
              <img src="data:image/png;base64,$qr_b64" alt="Entry QR"
                  style="display:block; width:100%; height:auto;
                          border:6px solid #fff; border-radius:8px; background:#fff;">
              <img src="data:image/png;base64,$logo_b64" alt="logo"
                  style="position:absolute; left:50%; top:50%;
                          transform:translate(-50%,-50%);
                          width:12%; height:auto;
                          background:#fff; padding:4px;
                          border-radius:8px; box-sizing:border-box;">
          </div>
      </div>
      """

      # ------ Build HTML for payment QR (visible) ------
      pay_qr_html = isempty(pay_qr_b64) ? "" : "<img src=\"data:image/png;base64,$pay_qr_b64\" alt=\"Payment QR\" style=\"max-width:420px; width:100%; height:auto; border:6px solid #fff; border-radius:8px; background:#fff;\">"
      scan_symbol = logo_base64_data("BalPopo/static/scan_symbol_QR.png")
      banklogos = logo_base64_data("BalPopo/static/BankLogos_Belgium_5icons.png")

      # ------ Final layout ------
      return layout("Registration Submitted", """
        <div class="content">
          <style>
            .content {
              text-align: center;
              max-width: 900px;
              margin: 40px auto;
              color: #fff;
              font-family: Arial, sans-serif;
            }

            h1 {
              font-size: 2.4rem;
              font-weight: 700;
              margin-bottom: 20px;
            }

            h2 {
              font-size: 1.4rem;
              margin: 20px 0 10px;
              color: #ffffff
            }

            .qr-box img.qr {
              max-width: 20px;
              width: 100%;
              height: auto;
              border: 6px solid #fff;
              border-radius: 8px;
              background: #fff;
            }

            .btn {
              background: #FFA500;
              color: #111;
              padding: 12px 20px;
              border-radius: 8px;
              font-size: 1.1rem;
              font-weight: 600;
              cursor: pointer;
              transition: 0.3s;
              border: none;
            }

            .btn:hover {
              background: #fff;
              color: #000;
            }

            .payment-section {
              display: flex;
              justify-content: center;
              align-items: flex-start;
              gap: 40px;
              flex-wrap: wrap;
              margin-top: 20px;
            }

            .qr-column {
              text-align: center;
              max-width: 400px
            }

            .qr-column img {
              display: block;
              margin: 10px auto;
              max-width: 100px
            }

            .instructions {
              text-align: left;
              max-width: 1000px;
              background: rgba(255,255,255,0.05);
              padding: 15px;
              border-radius: 8px;
              font-size: 1rem;
            }

            .instructions p {
              line-height: 1.6;
              margin-bottom: 12px;
              color: #ddd;
            }

            strong {
              color: #FFA500;
            }

            code {
              background: #222;
              color: #fff;
              padding: 4px 6px;
              border-radius: 4px;
            }

            .hidden {
              display: none;
            }

            @media (max-width: 768px) {
              .payment-section {
                flex-direction: column;
                align-items: center;
              }
              .btn {
                width: 100%;
                margin-top: 10px;
              }
            }
          </style>

          <h1>Thank you for registering!</h1>

          <!-- Payment QR -->
          <h2>Payment</h2>
          <div class="payment-section">
            <div class="qr-column">
              <img src="data:image/png;base64,$scan_symbol" style="height:160px;">
            </div>
            <div class="qr-column">
              $pay_qr_html
              <img src="data:image/png;base64,$banklogos" style="height:30px;">
            </div>
            <div class="qr-column">
            <div class="instructions">
            <p>
                  • beneficiary: </strong>KMS Promotie 177 POL FV</strong> <br>
                  • amount: <strong>€$(amount_eur)</strong> <br>
                  • IBAN: <strong>$(IBAN)</strong> <br>
                  • reference: <code>$(payment_ref)</code>.<br>
              </p>
              </div>
            </div>


            <div class="instructions">
              <p>
                • Scan this QR with your <strong>banking app</strong> (not Payconiq),
                or manually transfer the money with the correct details<br>
                • Check the details: if the <strong> reference </strong> is missing, enter it manually: <code>$(payment_ref)</code> <br>
                • Your registration is valid only after payment is received.
              </p>
            </div>
          </div>

          <!-- Entry QR -->
          <div class="qr-box">
            <h2>Entry QR</h2>
            <button id="toggleEntryQR" class="btn">Show entry code</button>
            <div id="entryQRWrap" class="hidden" style="margin-top:12px;">
              $entry_qr_inner
              <p style="margin-top:8px; color:#bbb; font-size:0.95rem;">
                You can also use the raw text: <code>$(unique_code)</code>
              </p>
            </div>
          </div>

          <p style="margin-top:12px; color:#ddd; font-size:0.95rem;">
            Lost your code? Just register again with the same details — your entry QR will be identical.  
            Payments are non-refundable once received.
          </p>

          <script>
            (function() {
              var btn = document.getElementById('toggleEntryQR');
              var wrap = document.getElementById('entryQRWrap');
              if (btn && wrap) {
                btn.addEventListener('click', function() {
                  var isHidden = wrap.classList.contains('hidden');
                  wrap.classList.toggle('hidden', !isHidden);
                  btn.textContent = isHidden ? 'Hide entry code' : 'Show entry code';
                });
              }
            })();
          </script>
        </div>
      """)
  catch e
      return layout("Error", "<p>There was an error processing your registration: $(e)</p>")
  end
end

route("/Registration", method = GET) do
  Captcha = logo_base64_data("BalPopo/static/Captcha.jpg")
  content = """
  <style>
  form {
    max-width: 700px;
    margin: 50px auto;
    padding: 0; /* No extra padding */
    background: transparent; /* Fully transparent */
    color: #fff;
  }

  label {
    color: #ccc; /* Light grey for labels */
    font-weight: 500;
  }


  h1 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 30px;
    color: #fff;
    text-align: center; /* Like your example */
  }

  .row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
  }

  input, select {
    width: 100%;
    padding: 12px 0;
    background: transparent;
    border: none;
    border-bottom: 1px solid #555; /* Thin underline */
    color: #fff;
    font-size: 1rem;
    margin-bottom: 20px;
  }

  input::placeholder, select {
    color: #ffffff;
    margin-bottom: 20px;
  }

  select option {
    background: #111;
    color: #fff;
  }


  input:focus, select:focus {
    border-bottom: 1px solid #fff;
    outline: none;
  }

  button {
    margin-top: 30px;
    width: 280px;
    padding: 14px;
    background: transparent;
    border: 2px solid #fff;
    color: #fff;
    font-size: 1.1rem;
    cursor: pointer;
    transition: 0.3s;
  }


  button:hover {
  background: #fff;
  color: #000;
  }


  .hidden {
    display: none;
  }

  .captcha-img {
    display: block;
    margin: 15px 0;
    max-width: 200px;
  }


  input:-webkit-autofill,
  input:-webkit-autofill:hover,
  input:-webkit-autofill:focus,
  textarea:-webkit-autofill,
  select:-webkit-autofill {
  background-color: transparent !important;
  color: #fff !important;
  -webkit-text-fill-color: #fff !important; /* Ensures white text */
  -webkit-box-shadow: 0 0 0px 1000px transparent inset !important;
  transition: background-color 5000s ease-in-out 0s;
  } 

  @media (max-width: 768px) {
  .row {
    grid-template-columns: 1fr; /* Stack fields vertically */
    gap: 10px; /* Reduce spacing for smaller screens */
  }

  form {
    margin: 20px; /* Reduce margin on mobile */
  }

  button {
    width: 100%; /* Full-width button on mobile */
  }
  }

  </style>


    <div class="content">
    <h1>Registration Form</h1>
    <form id="registrationForm" method="post" action="/Registration">
      <label for="participantType">Participant Type</label>
      <select id="participantType" name="participantType" required>
        <option value="">-- Select --</option>
        <option value="civil">Civilian</option>
        <option value="military">Military</option>
      </select>

      <div class="row">
        <div>
          <label for="salutation">Salutation</label>
          <select id="salutation" name="salutation" required>
            <option value="">-- Select --</option>
            <option value="Mr">Mr</option>
            <option value="Mrs">Mrs</option>
          </select>
        </div>
        <div>
          <label for="firstName">First Name</label>
          <input type="text" id="firstName" name="firstName" required autocomplete="given-name">
        </div>
      </div>

      <div class="row">
        <div>
          <label for="lastName">Last Name</label>
          <input type="text" id="lastName" name="lastName" required autocomplete="family-name">
        </div>
        <div>
          <label for="plusOne">Are you inviting a +1?</label>
          <select id="plusOne" name="plusOne" required>
            <option value="">-- Select --</option>
            <option value="Alone">Nah, I'm good</option>
            <option value="PlusOne">I'm bringing a +1 </option>
          </select>
        </div>
      </div>

      <div id="PlusOneExtras" class="hidden">
        <div class="row">
          <div>
            <label for="PlusOnefirstName">The +1's First Name </label>
            <input type="text" id="PlusOnefirstName" name="PlusOnefirstName" autocomplete="given-name">
          </div>
          <div>
            <label for="PlusOnelastName">+1's Last Name</label>
            <input type="text" id="PlusOnelastName" name="PlusOnelastName" autocomplete="family-name">
          </div>
        </div>
      </div>

      <div class="row">
        <div>
          <label for="email">Email Address</label>
          <input type="email" id="email" name="email" required autocomplete="email">
        </div>
        <div>
          <label for="phone">Phone Number (optional)</label>
          <input type="tel" id="phone" name="phone" autocomplete="tel">
        </div>
      </div>

      <label for="package">Package</label>
      <select id="package" name="package" required>
        <option value="">-- Select --</option>
        <option value="dance">Dance (€100)</option>
        <option value="dance_dinner">Dance + Dinner (€177)</option>
      </select>

      <div id="militaryExtras" class="hidden">
        <div class="row">
          <div>
            <label for="faculty">Faculty</label>
            <select id="faculty" name="faculty">
              <option value="">-- Select --</option>
              <option value="POL">POL 🧠</option>
              <option value="Other">Other 👩‍⚕️🩺</option>
              <option value="NCO">NCO 🫡⛺🔫</option>
              <option value="SSMW">SSMW</option>
            </select>
          </div>
          <div>
            <label for="promotion">Promotion</label>
            <input type="number" id="promotion" name="promotion" min="0" max="200" placeholder="">
          </div>
        </div>
      </div>

      <div id="captchaContainer" class="hidden">
        <label for="captcha">Verifying you are human: What's your favourite promotion? </label>
        <img src="data:image/jpeg;base64,$Captcha" class="captcha-img">
        <input type="text" id="captcha" name="captcha" placeholder="Enter captcha">
      </div>

      <button type="submit">Submit Registration</button>
    </form>
    </div>

    <script>
    (function() {
      const participantType = document.getElementById('participantType');
      const militaryExtras = document.getElementById('militaryExtras');
      const faculty = document.getElementById('faculty');
      const promotion = document.getElementById('promotion');

      const plusOne = document.getElementById('plusOne');
      const plusOneExtras = document.getElementById('PlusOneExtras');
      const PlusOnefirstName = document.getElementById('PlusOnefirstName');
      const PlusOnelastName = document.getElementById('PlusOnelastName');
      const packageSelect = document.getElementById('package');

      const captchaContainer = document.getElementById('captchaContainer');
      const captchaInput = document.getElementById('captcha');
      const form = document.getElementById('registrationForm');

      function toggleMilitaryExtras() {
        const isMil = participantType.value === 'military';
        militaryExtras.classList.toggle('hidden', !isMil);
        faculty.required = isMil;
        promotion.required = isMil && faculty.value !== 'NCO';
        promotion.disabled = faculty.value === 'NCO';
        checkFormCompletion();
      }

      function togglePlusOneExtras() {
        const show = plusOne.value === 'PlusOne';
        plusOneExtras.classList.toggle('hidden', !show);
        PlusOnefirstName.required = show;
        PlusOnelastName.required = show;
        if (!show) {
          PlusOnefirstName.value = '';
          PlusOnelastName.value = '';
        }
        packageSelect.options[1].text = show ? "Dance (€200)" : "Dance (€100)";
        packageSelect.options[2].text = show ? "Dance + Dinner (€354)" : "Dance + Dinner (€177)";
        checkFormCompletion();
      }

      function handleFacultyChange() {
        const isNCO = faculty.value === 'NCO';
        promotion.required = !isNCO && !militaryExtras.classList.contains('hidden');
        promotion.disabled = isNCO; // disable when NCO selected
        checkFormCompletion();
      }

      function checkFormCompletion() {
        const allValid = [...form.querySelectorAll('select[required], input[required]')]
          .filter(el => !el.closest('#captchaContainer'))
          .every(el => el.value.trim() !== '');
        captchaContainer.classList.toggle('hidden', !allValid);
        captchaInput.required = allValid;
      }

      participantType.addEventListener('change', toggleMilitaryExtras);
      faculty.addEventListener('change', handleFacultyChange);
      plusOne.addEventListener('change', togglePlusOneExtras);
      form.addEventListener('input', checkFormCompletion);

      form.addEventListener('submit', function(e) {
        // Ensure all conditionally visible fields are enabled for submission
        faculty.disabled = false;
        promotion.disabled = false;
        PlusOnefirstName.disabled = false;
        PlusOnelastName.disabled = false;

        if (captchaInput.value.toUpperCase() !== "177POL") {
          e.preventDefault();
          alert("Captcha is incorrect. Please try again.");
          captchaInput.value = "";
          captchaInput.focus();
        }
      });

      toggleMilitaryExtras();
      togglePlusOneExtras();
    })();
    </script>
    """
  layout("Registration", content)
end


route("/crook") do
  layout("Crookpagina", """
    <div class="hero">
      <h2>Proficiat!</h2>
    </div>
    <div class="content">
      <h1>Geheime pagina gevonden</h1>
      <p>U bent op de geheime pagina. Indien u SSMW bent ⇒ buiten!</p>
      <p>De naaktfoto's van de prom vind je hieronder:</p>
    </div>
  """)
end

route("/") do
    firstpic = background_base64_data("BalPopo/static/Fakkelparade 179.jpg")

    # Main section: text on left, placeholder image on right
    content = """

       <style>
        button { background: #C7AB4D; border-width: 3px; border-color: #C7AB4D; border-style: solid; color: #FFFFFF; padding: 10px 18px; font-family: "Poppins", sans-serif;
        font-weight: bold; font-size: 1.1rem; cursor: pointer; margin-top: 22px; width: 50%; }
        button:hover { background: #FFFFFF; color: #C7AB4D; border-style: solid;
        border-width: 3px; border-color: #C7AB4D; }
        .content p {
            text-align: justify;
        }

        /* Two-column layout */
        .main-section {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: flex-start;
            width: 100%;
            margin: 0 auto;
            padding: 20px; /* smaller default */
            gap: 20px;
            border-radius: 12px;
            box-sizing: border-box; /* ensures padding doesn't add extra width */
        }

        /* Mobile adjustments */
        @media (max-width: 768px) {
            .main-section {
                padding: 16px; /* reduce padding on small screens */
            }
        }
        .left {
            flex: 1 1 400px;
            color: #eee;
        }
        .left h2 {
          font-size: 2.2rem;
          color: #FFA500;
          margin-bottom: 20px;
        }

        hkwn {
          display: inline-block;
          font-size: clamp(3rem, 8vw, 4.5rem);
          color: #FFFFFF;
          font-family: "Poppins", sans-serif;
          font-weight: bold;
          line-height: 1;
          margin-bottom: 30px;
        }

        .text-logo {
          height: 1em; /* scales with text size */
          width: auto;
          vertical-align: middle; /* aligns nicely with text baseline */
          margin-left: 0.25em; /* small spacing */
        }

        .left p {
            font-size: 1.1rem;
            margin-bottom: 30px;
            color: #FFFFFF;
        }

        .right {
            flex: 1 1 300px;
            display: flex;
            justify-content: flex-end;
        }
        .right img {
            width: 100%;
            max-width: 600px;
        }

        .social-icons {
        display: flex;
        align-items: center;
        gap: 18px;            /* space between icons */
        margin-top: 25px;
       }

        .social-icons img {
          height: 30px;
          width: 30px;
          transition: transform 0.2s ease, opacity 0.2s ease;
          cursor: pointer;
        }

        .social-icons img:hover {
          transform: scale(1.1);
          opacity: 0.8;
        }
          .button-icons {
        display: flex;
        align-items: center;
        gap: 40px;
        margin-top: 25px;
         }

        .text-block {
        margin-top: 150px; 
        text-align:center;
        }

        html, body {
            overflow-x: hidden;
        }


  
    </style>

    <div class="main-section">
        <div class="left">
            <hkwn>
              WELCOME TO BALL POPO
              <img src="data:image/png;base64,$(logo_base64_data("BalPopo/static/logo_white.png"))"
                  alt="Ball Popo logo"
                  class="text-logo">
            </hkwn>
            <p>Whether you're an engineer, SDIV student, civilian partner, NCO or "social scientist", we'd like to welcome you to our website and invite you to Ball Popo!</p>
            <div class="button-icons">
            <button class="button" onclick="location.href='/theevent'">The Event</button>
            <div class="social-icons">
                <a href="https://www.facebook.com/YourPage" target="_blank">
                    <img src="data:image/png;base64,$(logo_base64_data("BalPopo/static/icons8-facebook-100.png"))" alt="Facebook">
                </a>
                <a href="https://www.instagram.com/YourPage" target="_blank">
                    <img src="data:image/png;base64,$(logo_base64_data("BalPopo/static/icons8-instagram-96.png"))" alt="Instagram">
                </a>
            </div>
          </div>
        </div>
        <div class="right">
            <img src="data:image/jpeg;base64,$firstpic" alt="Upcoming Event">
        </div>
        <div class="text-block">
        <h2> We CaRe about your ball</h2>
            <p>This year, it's the turn of 177 POL to organise the RMA's best evening.<br>
            Our promotion has done our absolute best to make this year’s ball POPO the best there ever was. 
            At a brand new location, we will offer you the best food, drinks and entertainment you could ever wish for! 
            The ball will start with a dinner of about 200 people, the rest of our eager guests will be joining right after to get the real party started that will last till 03:00. 
            The evening will be filled with several activities (tombola, karaoke,...), all the while our very own pop band entertains us with their music followed by the best DJ’s in the country.<br>
            Believe me, you wouldn’t wanna miss it. See you there!<br><br>
            xxx 177 POL</p>
            <h2>Practicalities:</h2>
            <p>DTG: 131800FEB26<br>Location:
            <a href="https://www.lafabbrica.be/en/" target="_blank" rel="noopener noreferrer">La Fabbrica</a>
            <br>Tickets: Pre-sale tickets are now available!</p>
        </div>
      </div>
    """

    layout("Home",content)
end

route("/sponsors") do
  data1 = logo_base64_data("BalPopo/static/LogoSeyntex.png")
  data2 = logo_base64_data("BalPopo/static/LogoOIP.png")
  data3 = logo_base64_data("BalPopo/static/logoBAE.jpg")
  content = """
  <div class="content">
    <div class="sponsor-header">
      <h1>Our sponsors</h1>
      <p>Like every year, the organisation of Ball Popo could count on the very generous support from certain companies, linked to the RMA's polytechnic faculty. Without their support, the Ball wouldn't have been able to turn into the event that it is now. Our gratitude goes out to these companies who are willing to partner with us:</p>
    </div>

    <div class="sponsor-section">
      <h2 style="color:gold">Gold</h2>
      <div class="sponsor-tier">
        <em>No one (for now!)</em>
      </div>

      <h2 style="color:silver">Silver</h2>
      <div class="sponsor-tier sponsor-cards">
        <div class="sponsor-card">
          <a href="https://www.seyntex.com" target="_blank">
            <strong style="color:#000">SEYNTEX</strong><br>
            <img src="data:image/png;base64,$data1" alt="Seyntex logo" class="sponsor-logo">
          </a>
        </div>
        <div class="sponsor-card">
          <a href="https://www.oip.be" target="_blank">
            <strong style="color:#000">OIP Sensor Systems</strong><br>
            <img src="data:image/png;base64,$data2" alt="OIP logo" class="sponsor-logo">
          </a>
        </div>
      </div>

      <h2 style="color:#cd7f32">Bronze</h2>
      <div class="sponsor-tier sponsor-cards">
        <div class="sponsor-card">
          <a href="https://www.baesystems.com/europe" target="_blank">
            <strong style="color:#000">BAE Systems</strong><br>
            <img src="data:image/png;base64,$data3"  alt="BAE logo" class="sponsor-logo">
          </a>
        </div>
      </div>
    </div>
  </div>

  <style>
    .sponsor-header {
      text-align: center;
      margin-bottom: 40px;
      color: #f0f0f0;
    }
    .sponsor-header h1 {
      font-size: 3em;
      margin-bottom: 0.5em;
    }
    .sponsor-header p {
      font-size: 1.1em;
      max-width: 800px;
      margin: 0 auto;
    }
    .sponsor-section {
      text-align: center;
      padding: 40px;
      color: #f0f0f0;
    }
    .sponsor-section h2 {
      font-size: 2.5em;
      margin-top: 40px;
    }
    .sponsor-tier {
      margin-bottom: 20px;
    }
    .sponsor-cards {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: 40px;
      margin-top: 20px;
    }
    .sponsor-card {
      background: #fff;
      border-radius: 12px;
      padding: 30px;
      max-width: 260px;
      text-align: center;
      transition: transform 0.2s;
      box-shadow: 0 6px 16px rgba(0,0,0,0.12);
    }
    .sponsor-card:hover {
      transform: scale(1.05);
    }
    .sponsor-logo {
      max-width: 180px;
      height: auto;
      margin-top: 12px;
    }
  </style>
  """
  layout("Sponsors", content)
end

route("/contact") do
  content = """
    <div class="content">
      <h1>Contact</h1>
      <p>General questions about the ball? Don't hesitate to contact us via e-mail:</p>
      <p><a href="mailto:bal@177pol.rma.ac.be">bal@177pol.rma.ac.be</a></p>

      <p>Questions about sponsorship? Head to:</p>
      <p><a href="mailto:sponsors@177pol.rma.ac.be">sponsors@177pol.rma.ac.be</a></p>

      <address>
        Renaissancelaan 30<br>
        1000 Brussel
      </address>
    </div>

    <style>
      .content {
        max-width: 700px;
        margin: auto;
        padding: 40px;
        color: #f0f0f0;
        line-height: 1.8em;
        font-size: 1.2em;
      }
      a {
        color: #ffd700;
        text-decoration: underline;
      }
      address {
        font-style: normal;
        color: #ccc;
      }
    </style>
  """
  layout("Contact", content)
end


route("/theevent") do
    content = """
    <div class="hero">
      <h2>The Event</h2>
      <p>Ball Popo — 177 POL</p>
    </div>

    <div class="content">
      <div class="event-grid">
        <!-- Info Card -->
        <div class="info-card">
          <h1>About the event</h1>
          <p><strong>Date:</strong> 13 februari 2026 — 18:00</p>
          <p><strong>Location:</strong> <a href="https://www.lafabbrica.be/en/" target="_blank" rel="noopener">La Fabbrica</a></p>
          <p><strong>Dresscode:</strong> Black tie (smocking, ball dresses and Gala/spencer for military)</p>

          <p style="margin-top:12px;">
            <a class="call-action" href="/Registration">Registration — Tickets</a>
          </p>
        </div>

        <!-- Media Card with YouTube -->
        <div class="media-card">
          <div class="video-wrapper">
            <iframe width="100%" height="240" src="https://www.youtube.com/embed/1FdIrTmtRzI" 
              title="Event Preview" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen>
            </iframe>
          </div>
          <p style="margin-top:8px; font-size:0.9rem; color:#ccc;">
            Secret preview.
          </p>
        </div>
      </div>

      <h2>Program</h2>
      <ul class="agenda">
        <li><strong>18:00</strong> — Reception for the hungry</li>
        <li><strong>19:30</strong> — Start dinner</li>
        <li><strong>21:30</strong> — Start dance</li>
        <li><strong>23:30</strong> — Trumpetsolo Riem</li>
      </ul>

      <h2>Bus schedule</h2>
      <p>Starting at midnight, every hour</p>
      <ul class="agenda">
        <li><strong>00:00</strong> — 2 busses</li>
        <li><strong>01:00</strong> — 1 bus</li>
        <li><strong>02:00</strong> — 1 bus</li>
        <li><strong>03:00</strong> — 1 bus</li>
        <li><strong>04:00</strong> — 2 busses</li>
      </ul>

      <p style="margin-top:18px; color:#ddd;">
        Questions? contact us: <a href="mailto:bal@177pol.rma.ac.be">bal@177pol.rma.ac.be</a>
      </p>
    </div>

    <style>
      .content {
        max-width: 1100px;
        margin: 40px auto;
        padding: 20px;
        box-sizing: border-box;
      }

      .event-grid {
        display: grid;
        grid-template-columns: 1fr 420px;
        gap: 24px;
        align-items: start;
        margin-bottom: 40px;
      }

      .info-card {
        padding: 18px;
        background: rgba(0,0,0,0.4);
        border-radius: 10px;
      }

      .media-card iframe {
        width: 100%;
        border-radius: 10px;
        box-shadow: 0 6px 18px rgba(0,0,0,0.5);
      }

      .agenda {
        list-style: none;
        padding-left: 0;
        margin-top: 8px;
      }

      .agenda li {
        padding: 8px 0;
        border-bottom: 1px dashed rgba(255,165,0,0.08);
        color: #ddd;
      }

      .info-card a.call-action {
        text-decoration: none;
        color: #ffb347;
        font-weight: bold;
      }

      .info-card a.call-action:hover {
        color: #ffd27f;
        text-decoration: underline;
      }

      .content a {
        color: #ffb347;
        text-decoration: none;
      }

      .content a:hover {
        color: #ffd27f;
        text-decoration: underline;
      }

      @media (max-width: 900px) {
        .event-grid {
          grid-template-columns: 1fr;
        }
        .media-card iframe {
          height: 200px;
        }
      }
    </style>
    """

    layout("The Event", content)
end


#=
# New simplified placeholder route
route("/theevent") do
  # Load the under construction image as base64
  uc_img = logo_base64_data("BalPopo/static/under_construction2.jpg")

  # Simple content with the image centered
  content = """
      <div class="content" style="text-align:center; margin-top:40px;">
          <h2>Page under construction</h2>
          <p>Please check back later for more details.</p>
          <img src="data:image/png;base64,$uc_img" alt="Under construction" 
               style="margin-top:20px; max-width:400px; border-radius:10px;">
      </div>
  """

  layout("The Event", content)
end
=#

route("/legal") do
    content = """
    <style>
      .content {
        max-width: 1000px;
        margin: 80px auto;
        padding: 20px;
      }

      h3 {
        margin-top: 2em;
        margin-bottom: 0.8em;
        font-size: 1.4em;
      }

      .legal-text {
        margin-bottom: 2em;
      }

      .legal-text p {
        text-align: justify;
        margin: 12px 0;
        line-height: 1.6;
      }

      .legal-text b {
        display: block;
        margin-top: 12px;
        margin-bottom: 8px;
      }

      a {
        color: #ADD8E6;
        text-decoration: underline;
      }

      a:hover {
        color: #FFD580;
      }
    </style>

    <div class="content">

      <h3>Wettelijke informatie</h3>
      <div class="legal-text">
        <p>Bal Popo 177 is het bal dat op 13/02/2026 zal plaatsvinden, georganiseerd door de feitelijke vereniging onder de naam "KMS Promotie 177 POL". De vereniging heeft tot doel het organiseren van het jaarlijks galabal van de polytechnische faculteit van de Koninklijke Militaire School in het schooljaar 2025-2026.</p>

        <p>Verenigingsnummer: V0013470. De details van de feitelijke vereniging kan u <a href="https://www.verenigingsloket.be/nl/verenigingen/V0013470-kms-promotie-177-pol"target="_blank" rel="noopener noreferrer">hier</a> vinden. De vereniging zal ontbonden worden wanneer alle schulden betaald zijn.</p>

        <p>Het bestuur van de vereniging wordt toevertrouwd aan Ben Van Steendam als voorzitter en Iebe Riem als penningmeester. Zij oefenen hun mandaat kosteloos uit. Het bestuur leidt de zaken van de vereniging. Ten aanzien van derden is de vereniging geldig verbonden door de handtekening van de voorzitter of Iebe Riem of Henrik Van Overvelt elk afzonderlijk.</p>

        <p>Bij ontbinding zal de algemene vergadering beslissen de financiële activa, na aanzuivering van de schulden, over te dragen aan een vereniging met een sociaal, menslievend doel.</p>
      </div>

      <h3>Ondersteunende bedrijven</h3>
      <div class="legal-text">
        <b>Volgende paragraaf geeft de mening van het organisatorisch team weer en niet die van de KMS, de polytechnische faculteit of Defensie.</b>
        <p>De aard van het evenement en onze faculteit gebiedt ons voor sponsoring toenadering te zoeken bij bedrijven die gelinkt zijn aan de KMS, Defensie, en de Belgische industrie. Hoewel de Belgische Defensie-industrie en haar investeringen/samenwerkingen als positief wordt ervaren, begrijpen wij dat dit niet noodzakelijk geldt voor al haar partners. Onder onze sponsors zitten er bedrijven die gesteund worden door overheden die mogelijk inbreuken plegen tegen het internationaal recht.</p>
        <p><b>De financiële steun van deze bedrijven betekent geenszins dat wij ons akkoord verklaren met de politiek die dergelijke overheden voeren.</b></p>
      </div>

      <h3>Informations légales</h3>
      <div class="legal-text">
        <p>Bal Popo 177 est le bal qui aura lieu le 13/02/2026, organisé par l'association de fait sous le nom "ERM Promotion 177 POL". L'association a pour but d'organiser le bal annuel de la faculté polytechnique de l'École Royale Militaire pour l'année scolaire 2025-2026.</p>

        <p>Numéro d'association : V0013470. Vous pouvez trouver les détails de l'association de fait <a href="https://www.verenigingsloket.be/nl/verenigingen/V0013470-kms-promotie-177-pol">ici</a>. L'association sera dissoute lorsque toutes les dettes auront été réglées.</p>

        <p>La gestion de l'association est confiée à Ben Van Steendam en tant que président et Iebe Riem en tant que trésorier. Ils exercent leur mandat à titre gratuit. Le conseil gère les affaires de l'association. À l'égard des tiers, l'association est valablement engagée par la signature du président, d'Iebe Riem ou de Henrik Van Overvelt, chacun séparément.</p>

        <p>En cas de dissolution, l'assemblée générale décidera de transférer les actifs financiers, après apurement des dettes, à une association poursuivant un but social ou caritatif.</p>

        <h3>Entreprises partenaires</h3>
        <b>Le paragraphe suivant reflète l'opinion de l'équipe organisatrice et non celle de l'ERM, de la faculté polytechnique ou du Ministère de la Défense.</b>
        <p>En raison de la nature de l'événement et de notre faculté, nous sollicitons des sponsors auprès d'entreprises liées à l'ERM, à la Défense et à l'industrie belge. Bien que l'industrie de la défense belge et ses investissements/partenariats soient perçus positivement par certains, nous comprenons que cela ne s'applique pas nécessairement à tous leurs partenaires. Parmi nos sponsors figurent des entreprises soutenues par des gouvernements susceptibles de commettre des violations du droit international.</p>
        <p><b>Le soutien financier de ces entreprises n'implique en aucun cas que nous approuvions la politique de tels gouvernements.</b></p>
      </div>

      <h3>Legal Information</h3>
      <div class="legal-text">
        <p>Bal Popo 177 is the ball that will take place on 13/02/2026, organized by the de facto association under the name "KMS Promotie 177 POL" in Dutch and "ERM Promotion 177 POL" in French. The association aims to organize the annual gala of the polytechnic faculty of the Royal Military Academy for the 2025-2026 academic year.</p>

        <p>Association number: V0013470. You can find the details of the de facto association <a href="https://www.verenigingsloket.be/nl/verenigingen/V0013470-kms-promotie-177-pol">here</a>. The association will be dissolved once all debts have been paid.</p>

        <p>The board is entrusted to Ben Van Steendam as president and Iebe Riem as treasurer. They perform their duties free of charge. The board manages the affairs of the association. In dealings with third parties, the association is validly represented by the signature of the president, Iebe Riem, or Henrik Van Overvelt, each acting individually.</p>

        <p>Upon dissolution, the general assembly shall decide to transfer any remaining financial assets, after settling the debts, to an association with a social or charitable purpose.</p>

        <h3>Supporting companies</h3>
        <b>The following paragraph expresses the opinion of the organising team and not that of the Royal Military Academy, the Polytechnic Faculty, or the Ministry of Defence.</b>
        <p>Because of the nature of the event and our faculty, we seek sponsorship from companies connected to the RMA, Defence, and the Belgian industry. While the Belgian defence industry and its investments/partnerships are regarded positively, we understand that this may not apply to all of their partners. Among our sponsors are companies that are supported by governments that may commit violations of international law.</p>
        <p><b>The financial support of these companies in no way implies that we endorse the policies of such governments.</b></p>
      </div>

    </div>
    """

    layout("Legal", content)
end

route("/Privacy policy") do
    content = """
            <style>
      .content {
        max-width: 1000px;
        margin: 80px auto;
        padding: 20px;
      }

      h3 {
        margin-top: 2em;
        margin-bottom: 0.8em;
        font-size: 1.4em;
      }

      .legal-text {
        margin-bottom: 2em;
      }

      .legal-text p {
        text-align: justify;
        margin: 12px 0;
        line-height: 1.6;
      }

      .legal-text b {
        display: block;
        margin-top: 12px;
        margin-bottom: 8px;
      }

      a {
        color: #ADD8E6;
        text-decoration: underline;
      }

      a:hover {
        color: #FFD580;
      }
    </style>


      <div class="content">
        <p>
        European privacy laws (GDPR) require websites to clearly explain what data they collect, how, and why. (You too, <a href="https://projectssmw.be" target="_blank">Project SSMW</a>)
        This privacy notice explains in clear terms what data we collect, how we use it, and what your rights are. It is based on the official 
        <a href="https://gdpr.eu/privacy-notice/" target="_blank">guidelines from the European Union</a>. 
        You can find more general information about the GDPR 
        <a href="https://gdpr.eu/what-is-gdpr/" target="_blank">here</a>.<br><br>
        The privacy notice is available in English, Dutch and French.
        </p>

        <h1>Nederlandse versie</h1>

        <h3>1. Wie zijn wij?</h3>
        Zie de <a href="/legal">legal</a> pagina voor details over de vereniging. 

        <h3>2. Welke persoonsgegevens verzamelen wij?</h3>
        <h3>Identificatiegegevens</h3>
        <h4>Naam, voornaam, promotie en faculteit</h4>

        <h3>Contactgegevens</h3>
        <h4>E-mailadres, telefoonnummer (optioneel)</h4>

        <h3>Technische gegevens</h3>
        <h4>IP-adres, apparaat en browser</h4>

        <h3>Betaalinformatie</h3>
        <h4>Transactiedetails zoals tijdstip, naam van de rekeninghouder, bedrag en referentie.</h4>

        <h3> 3. Hoe verzamelen we die gegevens? </h3>
        <p>Websites verzamelen automatisch data over IP-adres, browser, apparaat, resolutie,... juist zoals de onze. De andere data die we gebruiken is data die u zelf invult via het inschrijvingsformulier of via uw betaling.</p>

        <h3> 4. Hoe gebruiken we uw data ?</h3>
        <p> De gegevens op het inschrijvingsformulier zijn noodzakelijk om de identificatie goed te kunnen laten verlopen wanneer Bal Popo plaatsvindt. IP-adres met benaderde locatie wordt enkel gebruikt om statistieken over de website bij te kunnen houden en om te kunnen controleren of een inschrijving legitiem is. 

        <h3> 5. Hoe slaan we uw gegevens op? </h3>
        <p> De data wordt enkel opgeslagen op onze server die zich op de KMS bevindt. Alle data zal ten laatste één maand na het bal verwijderd worden (15/03/2026), en minstens opgeslagen worden tot aan het bal (14/02/2026).</p>

        <h3> 6. Hoe is uw data beschermd? </h3> 
        <p> Uw contactgegevens (emailadres en eventueel telefoonnummer) worden verborgen opgeslagen. De sleutel wordt niet gedeeld buiten het organisatorisch comité van het bal. 
        Enkel uw identificatiegegevens worden zonder codering opgeslagen om de eenvoudige reden dat wij u zo alsnog vlot toegang kunnen geven tot het bal als uw opslagapparaat met uw QR code ineens zou ophouden met naar behoren te functioneren. 
        De fysieke veiligheid van de server wordt gegarandeerd door de S2 van de KMS, in samenwerking met G4S. Omdat wij zo'n dergelijk groot vertrouwen hebben in de veiligheidsofficier, is het ons inziens onnodig om uw data volledig te encrypteren.</p>

        <h3> 7. Welke rechten heeft u? </h3>
        <p> Als u zinnens bent uw rechten ten volle uit te oefenen, gelieve u te wenden tot de <a href="/contact">contactpagina</a> van de website en ons zo een mailtje te sturen. Wij hebben maximaal 30 dagen om u van antwoord te voorzien.
        Het overzicht en inspiratiebron voor deze lijst van uw rechten als gebruiker vindt u op de website van de Belgische <a href="https://www.gegevensbeschermingsautoriteit.be/burger/privacy/wat-zijn-mijn-rechten">gegevensbechermingsautoriteit</a>.</p>
        <h3> Recht om je gegevens in te kijken</h3> 
        <p> U heeft het recht om uw opgeslagen gegevens op te vragen. </p>

        <h3> Recht om je gegevens aan te passen</h3> 
        <p> U heeft het recht om uw persoonlijke gegevens aan te vullen of te verbeteren als u van mening bent dat er foute info werd opgeslagen. </p>
        
        <h3> Recht om je gegevens te laten wissen</h3>
        <p> U heeft het recht de info die we van u hebben opgeslagen, te laten verwijderen. Hou er rekening mee dat uw inschrijving in dit geval in het gedrang kan komen en een terugbetaling van uw ticket niet gegarandeerd is. </p> 

        <h3> Recht om de verwerking te beperken </h3>
        <p> U hebt het recht om te vragen dat uw data slechts beperkt verwerkt wordt. Hiervoor moet uw situatie voldoen aan een van 3 gevallen, die u vindt op de website van de Belgische gegevensbeschermingsautoriteit.</p> 

        <h3> Recht om je te verzetten tegen de verwerking van je persoonsgegevens en tegen automatische beslissingen</h3> 
        <p> U hebt het recht om te vragen dat we uw data helemaal niet verwerken. Houd er ook in dit geval rekening mee dat uw inschrijving voor het bal in het gedrang kan komen. </p> 

        <h3> Recht om je gegevens over te zetten</h3>
        <p> U mag eisen dat we uw opgeslagen gegevens overbrengen aan een ander bedrijf, vereniging, organisatie of persoon. </p>

        <h3> Recht om je toestemming in te trekken</h3>
        <p> U mag -zonder verdere uitleg- uw toestemming voor gegevensverwerking intrekken. </p>

        <h3> 8. Cookies 🍪</h3> 
        <p> Deze website maakt geen gebruik van koekjes. </p>

        <h3> 9. Links naar andere sites </h3> 
        <p> Dit privacybeleid is enkel van toepassing op deze website, niet op de websites waar u naar doorverwezen kan worden vanaf de onze. </p>

        <h3> 10. Wijzigingen </h3>
        <p> Wijzigingen in ons privacybeleid zullen niet gecommuniceerd worden tenzij u ons via de contactpagina duidelijk maakt dat u dat wel wil. Deze versie van het beleid dateert van 18/08/2025. </p>

        <h3> 11. Hoe ons te bereiken? </h3> 
        <p>
            Via de <a href="/contact">contactpagina</a> van de website.
            Als u binnen 30 dagen geen antwoord ontvangt, kunt u contact opnemen via:
            <a href="mailto:ben.vansteendam@mil.be">ben.vansteendam@mil.be</a> of
            <a href="mailto:henrik.vanovervelt@mil.be">henrik.vanovervelt@mil.be</a>.
        </p>
        
        <h3> Hoe de toezichthoudende gegevensbechermingsautoriteit bereiken? </h3> 
        <p>
            Enkel bij ernstige klachten: <a href="https://www.gegevensbeschermingsautoriteit.be/burger/acties/bemiddeling-aanvragen" target="_blank" rel="noopener noreferrer">
                bemiddeling aanvragen 
            </a> of <a href="https://www.gegevensbeschermingsautoriteit.be/burger/acties/klacht-indienen" target="_blank" rel="noopener noreferrer">
                klacht indienen</a>. Misbruik van dit kanaal kan negatieve gevolgen hebben voor onze vereniging en vlekkeloze reputatie op de KMS.
        </p> 

        
        
        <h1>English version</h1>

        <h3>1. Who are we?</h3>
        See the <a href="/legal">legal</a> page for details about the association.

        <h3>2. What personal data do we collect?</h3>
        <h3>Identification data</h3>
        <h4>Name, first name, promotion, and faculty</h4>

        <h3>Contact data</h3>
        <h4>Email address, phone number (optional)</h4>

        <h3>Technical data</h3>
        <h4>IP address, device and browser</h4>

        <h3>Payment data</h3>
        <h4>Transaction details such as timestamp, account holder’s name, and amount</h4>

        <h3>3. How do we collect this data?</h3>
        <p>Some data is collected automatically when you visit the website (e.g., IP address, browser, resolution). Other data is submitted manually via our registration form.</p>

        <h3>4. How do we use your data?</h3>
        <p>Registration data is needed to properly identify you at the event. IP and location data is used for analytics and to prevent fraudulent registrations.</p>

        <h3>5. How do we store your data?</h3>
        <p>All data is stored securely on our server at KMS. It will be deleted at the latest one month after the ball (by 15/03/2026), and kept at least until the event (14/02/2026).</p>

        <h3>6. How is your data protected?</h3>
        <p>Your contact details (email address and optionally phone number) are stored in an obfuscated manner. The key is not shared outside the organizing committee of the ball.  
        Only your identification data is stored without encryption, for the simple reason that this allows us to grant you smooth access to the ball in case your device containing the QR code suddenly stops functioning properly.  
        The physical security of the server is guaranteed by the RMA's S2, in cooperation with G4S. Because of the high level of trust we place in the security officer, we consider it unnecessary to fully encrypt your data.</p>

        <h3>7. What are your rights?</h3>
        <p>To exercise your rights, contact us via the <a href="/contact">contact page</a>. We will respond within 30 days. An overview of your rights can be found on the Belgian <a href="https://www.gegevensbeschermingsautoriteit.be/burger/privacy/wat-zijn-mijn-rechten">Data Protection Authority</a>.</p>

        <h3>Right to access</h3> 
        <p>You may request access to your stored data.</p>

        <h3>Right to rectification</h3> 
        <p>You may ask to correct or complete inaccurate data.</p>

        <h3>Right to erasure</h3>
        <p>You may request data deletion, though this may impact your registration.</p>

        <h3>Right to restriction of processing</h3>
        <p>You may ask to restrict processing if your situation meets specific conditions.</p>

        <h3>Right to object</h3>
        <p>You may object to data processing, which may impact your registration.</p>

        <h3>Right to data portability</h3>
        <p>You may request to transfer your data to another entity.</p>

        <h3>Right to withdraw consent</h3>
        <p>You may withdraw your consent at any time.</p>

        <h3>8. Cookies 🍪</h3>
        <p>This website does not use cookies.</p>

        <h3>9. Links to other sites</h3>
        <p>This policy only applies to our website, not to linked sites.</p>

        <h3>10. Changes</h3>
        <p>This policy was last updated on 18/08/2025. Changes will not be notified unless requested via the contact page.</p>

        <h3>11. How to contact us?</h3>
        <p>Use the <a href="/contact">contact page</a>. If no reply within 30 days, write to <a href="mailto:ben.vansteendam@mil.be">ben.vansteendam@mil.be</a> or <a href="mailto:henrik.vanovervelt@mil.be">henrik.vanovervelt@mil.be</a>.</p>

        <h3>How to reach the supervisory authority?</h3>
        <p>Only for serious complaints: <a href="https://www.gegevensbeschermingsautoriteit.be/burger/acties/bemiddeling-aanvragen" target="_blank" rel="noopener noreferrer">request mediation</a> or <a href="https://www.gegevensbeschermingsautoriteit.be/burger/acties/klacht-indienen" target="_blank" rel="noopener noreferrer">file a complaint</a>.
        Misuse of this channel may have negative consequences for our association and for our spotless reputation at the RMA.</p>

        <h1>Version française</h1>

        <h3>1. Qui sommes-nous ?</h3>
        Voir la page <a href="/legal">mentions légales</a> pour plus de détails concernant l’association.

        <h3>2. Quelles données personnelles collectons-nous ?</h3>
        <h3>Données d’identification</h3>
        <h4>Nom, prénom, promotion et faculté</h4>

        <h3>Données de contact</h3>
        <h4>Adresse e-mail, numéro de téléphone (optionnel)</h4>

        <h3>Données techniques</h3>
        <h4>Adresse IP, appareil, navigateur</h4>

        <h3>Données de paiement</h3>
        <h4>Détails des transactions : heure, nom du titulaire du compte, montant</h4>

        <h3>3. Comment collectons-nous vos données ?</h3>
        <p>Certaines données sont collectées automatiquement via le site (IP, navigateur, etc.). D'autres sont fournies par vous via le formulaire d’inscription.</p>

        <h3>4. Comment utilisons-nous vos données ?</h3>
        <p>Les données d’inscription sont nécessaires pour l’identification lors du bal. L’adresse IP est utilisée à des fins statistiques et pour vérifier les inscriptions frauduleuses.</p>

        <h3>5. Comment stockons-nous vos données ?</h3>
        <p>Toutes les données sont stockées sur notre serveur à la KMS. Elles seront supprimées au plus tard le 15/03/2026 et conservées au moins jusqu’au bal (14/02/2026).</p>

        <h3>6. Comment protégeons-nous vos données ?</h3>
        <p>Vos coordonnées de contact (adresse e-mail et éventuellement numéro de téléphone) sont stockées de manière protégée. La clé n’est pas partagée en dehors du comité d’organisation du bal.  
        Seules vos données d’identification sont conservées sans chiffrement, pour la simple raison que cela nous permet de vous donner rapidement accès au bal au cas où votre appareil contenant le QR code cesserait soudainement de fonctionner correctement.  
        La sécurité physique du serveur est garantie par le S2 de l'ERM, en collaboration avec G4S. Étant donné la grande confiance que nous accordons à l’officier de sécurité, nous considérons qu’il n’est pas nécessaire de chiffrer entièrement vos données.</p>


        <h3>7. Quels sont vos droits ?</h3>
        <p>Pour exercer vos droits, contactez-nous via la <a href="/contact">page de contact</a>. Nous avons 30 jours pour vous répondre. Vos droits sont expliqués sur le site de l’<a href="https://www.autoriteprotectiondonnees.be/citoyen/agir/portail-plainte" target="_blank">Autorité de protection des données</a>.</p>

        <h3>Droit d’accès</h3>
        <p>Vous pouvez demander une copie de vos données personnelles.</p>

        <h3>Droit de rectification</h3>
        <p>Vous pouvez corriger des données inexactes ou incomplètes.</p>

        <h3>Droit à l’effacement</h3>
        <p>Vous pouvez demander la suppression de vos données. Cela pourrait annuler votre inscription.</p>

        <h3>Droit à la limitation du traitement</h3>
        <p>Vous pouvez limiter le traitement dans certains cas précisés par la loi.</p>

        <h3>Droit d’opposition</h3>
        <p>Vous pouvez vous opposer au traitement. Cela pourrait affecter votre inscription.</p>

        <h3>Droit à la portabilité</h3>
        <p>Vous pouvez demander le transfert de vos données à une autre entité.</p>

        <h3>Droit de retirer votre consentement</h3>
        <p>Vous pouvez retirer votre consentement sans justification.</p>

        <h3>8. Cookies 🍪</h3>
        <p>Ce site n’utilise pas de cookies.</p>

        <h3>9. Liens vers d’autres sites</h3>
        <p>Cette politique ne s’applique qu’à notre site, pas aux liens externes.</p>

        <h3>10. Modifications</h3>
        <p>Ce texte est daté du 18/08/2025. Les modifications ne seront envoyées que sur demande via la page de contact.</p>

        <h3>11. Nous contacter</h3>
        <p>Via la <a href="/contact">page de contact</a>. En cas de non-réponse sous 30 jours, contactez <a href="mailto:ben.vansteendam@mil.be">ben.vansteendam@mil.be</a> ou <a href="mailto:henrik.vanovervelt@mil.be">henrik.vanovervelt@mil.be</a>.</p>

        <h3>Contacter l’autorité de protection des données</h3>
        <p>En cas de plainte grave : <a href="https://www.autoriteprotectiondonnees.be/citoyen/agir/introduire-une-plainte" target="_blank">porter plainte</a> ou 
        <a href="https://www.autoriteprotectiondonnees.be/citoyen/agir/demander-une-mediation" target="_blank">demander une médiation</a>. Un usage abusif de ce canal peut avoir des conséquences négatives pour notre association et pour notre réputation irréprochable à l'ERM.</p>

      </div>
    """
    layout("Privacy policy", content)
end

route("/ourstory") do
    # Laad afbeeldingen als base64
    img1 = logo_base64_data("BalPopo/static/story1.jpeg")
    img2 = logo_base64_data("BalPopo/static/story2.jpeg")
    img3 = logo_base64_data("BalPopo/static/story3.jpeg")
    # img4 = logo_base64_data("BalPopo/static/Rodeo.jpg")
    img5 = logo_base64_data("BalPopo/static/Paintball1Ba.jpg")
    img6 = logo_base64_data("BalPopo/static/Budapest2.jpg")
    img7 = logo_base64_data("BalPopo/static/Frigate2.jpg")
    img8 = logo_base64_data("BalPopo/static/Budapest3.jpg")

    content = """
      <style>
        .content {
            max-width: 1100px;       /* Optional: limit width for large screens */
            margin: 100px auto;          /* Centers the content horizontally */
            padding: 20px;           /* Adds space inside the container */
            box-sizing: border-box;  /* Ensures padding doesn’t break layout */
          }

        .story-block {
          margin: 40px 0;
          text-align: center;
          max-width: 100%;
        }
        .story-block img {
          max-width: 100%;
          border-radius: 12px;
          box-shadow: 0 6px 20px rgba(0,0,0,0.4);
        }
        .caption {
          margin-top: 10px;
          font-style: italic;
          color: #ccc;
        }
      </style>

      <div class="content">
        <h1>DECET IMPERATOREM STANTEM MORI</h1>
        <p>Since it's inception in October 2022, 177 POL has been known to the RMA as a particular group of close comrades. </p>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img5" alt="Afbeelding 5">
          <p class="caption">One of the first cohesion activities, back when 177 counted more than 40 effectives</p>
        </div>

        <h1>...comme des planètes</h1>

        <p> In the months following the evolution from platoon to promotion, our identity as a promotion was formed. Our official color, logo and animal were chosen
        and proudly displayed on the proper occasions. 

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img3" alt="Afbeelding 3">
          <p class="caption">The mighty lynx</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img8" alt="Afbeelding 8">
          <p class="caption">177 in Budapest</p>
        </div>

        <p> Counting 28 members, we're one of the biggest promotions of the faculty and a huge reception center for the fallen cousins of our <i>parrain</i> prom. Every obstacle (and there are a lot!) formed the promotion a bit more into the group we are now.</p>
        
        <div class="story-block">
          <img src="data:image/jpeg;base64,$img1" alt="Afbeelding 1">
          <p class="caption">177 after giving birth to 179</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img2" alt="Afbeelding 2">
          <p class="caption">The 177-frigate with it's detachable 40mm-cannon. Ammunition includes APFSDS rounds, HE rounds, blank 5.56 munition, a broomstick, and -occasionally- a vegetable or croissant.</p>
        </div>

        <p> Being the first POL prom with members in every military branch and being the first ones to develop freely in a cadreless L2 block, 
        everyone knew 177 wasn't meant to be just another random prom. We didn't stop enforcing our brotherhood 24/7: going on holidays, making an... -artistic- calendar, 
        hallway to shooting range conversions and many other top secret activities have led to this unique group of people organising an even more unique event. </p>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img6" alt="Afbeelding 6">
          <p class="caption">177's first international adventure</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img7" alt="Afbeelding 7">
          <p class="caption">The frigate in it's personnel carrier configuration </p>
        </div>

      </div>
    """

    layout("Our Story", content)
end

# GET route (unchanged)
route("/admin/checkin", method = GET) do
  content = """
  <div class="content">
    <h1>Admin: Check-in / Decode QR code</h1>
    <p>This page decodes the encrypted code stored in the QR and can mark the matching registration <strong>paid</strong> in the CSV.</p>

    <form method="post" action="/admin/checkin">
      <label for="admin_key">Admin key (if set):</label><br/>
      <input type="password" id="admin_key" name="admin_key" style="width:100%; padding:8px; margin:6px 0;"><br/>

      <label for="code">Scanned code (paste the QR text or the code):</label><br/>
      <input type="text" id="code" name="code" style="width:100%; padding:8px; margin:6px 0;" required><br/>

      <button type="submit" style="background:#FFA500;padding:10px 14px;border-radius:6px;border:none;cursor:pointer;">Decode / Check</button>
    </form>

    <p style="margin-top:16px; color:#ccc;">
      Note: set <code>ENV["ADMIN_KEY"]</code> to protect this page. If not set, the page is unprotected (use only locally).
    </p>
  </div>
  """
  layout("Admin check-in", content)
end

# Corrected POST route (fixed string building to avoid the parse error)
route("/admin/checkin", method = POST) do
  try
    data = params()
    safe_get = key -> begin
        v = get(data, Symbol(key), nothing)
        v === nothing ? "" : String(v)
    end

    provided_key = safe_get("admin_key")
    provided_code = strip(safe_get("code"))
    action_mark = safe_get("mark")  # present when the user clicked "Mark as paid"

    env_key = get(ENV, "ADMIN_KEY", "")

    # If an ADMIN_KEY is configured, require it
    if !isempty(env_key) && provided_key != env_key
        return layout("Forbidden", "<div class=\"content\"><h1>Forbidden</h1><p>Invalid admin key.</p></div>")
    end

    if isempty(provided_code)
        return layout("Check-in", "<div class=\"content\"><p>No code provided.</p></div>")
    end

    # Attempt decryption using existing helper
    decoded = ""
    ok_decode = true
    try
      decoded = xor_decrypt_base64(provided_code)   # uses existing function in your file
    catch e
      ok_decode = false
      decoded = string("Decoding error: ", sprint(showerror, e))
    end

    decoded_fields = ["(invalid)","(invalid)","(invalid)"]
    if ok_decode
      parts = split(decoded, "||")
      for i in 1:3
        decoded_fields[i] = i <= length(parts) ? parts[i] : ""
      end
    end

    # Read CSV and find matching registration (uniqueCode column)
    found_idx = nothing
    found_row_html = ""
    paid_before = "(unknown - CSV missing)"
    match_count = 0
    df = nothing
    try
      if isfile(CSV_FILE)
        df = CSV.read(CSV_FILE, DataFrame)

        if :uniqueCode in names(df)
          matches = findall(x -> !ismissing(x) && String(x) == provided_code, df[!, :uniqueCode])
          match_count = length(matches)
          if match_count > 0
            found_idx = matches[1]
            # prepare values in a safe way (avoid indexing errors)
            row = df[found_idx, :]

            ts = try string(row[:timestamp]) catch; "" end
            fname = try string(row[:firstName]) catch; "" end
            lname = try string(row[:lastName]) catch; "" end
            fullname = strip((isempty(fname) ? "" : fname * " ") * lname)
            package = try string(row[:package]) catch; "" end
            email = try string(row[:email]) catch; "" end
            phone = try string(row[:phone]) catch; "" end
            pref = (:paymentRef in names(df)) ? string(df[found_idx, :paymentRef]) : ""
            paid_before = (:paid in names(df)) ? string(df[found_idx, :paid]) : "(no paid column)"

            # Build the HTML table safely (no inline ternary inside interpolation)
            found_row_html = "<h3>Matched registration (first match)</h3><ul>" *
                            "<li><strong>Timestamp:</strong> " * escape_html(ts) * "</li>" *
                            "<li><strong>Name:</strong> " * escape_html(fullname) * "</li>" *
                            "<li><strong>Package:</strong> " * escape_html(package) * "</li>" *
                            "<li><strong>Email:</strong> " * escape_html(email) * "</li>" *
                            "<li><strong>Phone:</strong> " * escape_html(phone) * "</li>" *
                            "<li><strong>paymentRef:</strong> " * escape_html(pref) * "</li>" *
                            "<li><strong>paid:</strong> " * escape_html(paid_before) * "</li>" *
                            "</ul>"
          else
            found_row_html = "<p>No matching registration found in $(CSV_FILE) for this code.</p>"
          end
        else
          found_row_html = "<p>CSV does not contain a <code>uniqueCode</code> column.</p>"
        end
      else
        found_row_html = "<p>CSV file not found: <code>$(CSV_FILE)</code></p>"
      end
    catch e
      found_row_html = "<p>Error reading CSV: $(sprint(showerror,e))</p>"
    end

    # If the admin asked to mark paid and we have a match -> update CSV
    mark_result_html = ""
    if !isempty(action_mark) && found_idx !== nothing && df !== nothing
      try
        # ensure :paid exists
        if !(:paid in names(df))
          df[!, :paid] = fill("false", nrow(df))
        end
        df[found_idx, :paid] = "true"
        CSV.write(CSV_FILE, df)  # rewrite CSV
        mark_result_html = "<p style=\"color:lightgreen;\"><strong>Marked as paid (and CSV updated).</strong></p>"
      catch e
        mark_result_html = "<p style=\"color:salmon;\"><strong>Failed to mark as paid:</strong> $(sprint(showerror,e))</p>"
      end
    end

    # Build result page: decoded payload + matched row + optional mark button
    decoded_pretty = ok_decode ? """
      <h2>Decoded payload</h2>
      <ul>
        <li><strong>Full name:</strong> $(escape_html(decoded_fields[1]))</li>
        <li><strong>Plus-one:</strong> $(escape_html(decoded_fields[2]))</li>
        <li><strong>Selected package:</strong> $(escape_html(decoded_fields[3]))</li>
      </ul>
    """ : "<p style=\"color:salmon;\">$decoded</p>"

    mark_form = ""
    if found_idx !== nothing
      mark_form = """
        <form method="post" action="/admin/checkin" style="margin-top:12px;">
          <input type="hidden" name="admin_key" value="$(escape_html(provided_key))">
          <input type="hidden" name="code" value="$(escape_html(provided_code))">
          <input type="hidden" name="mark" value="1">
          <button type="submit" style="background:#28a745;color:white;padding:8px 12px;border-radius:6px;border:none;cursor:pointer;">
            Mark registration as PAID
          </button>
        </form>
      """
    end

    content = """
    <div class="content">
      <h1>Check-in result</h1>
      <p><strong>Provided code:</strong> <code>$(escape_html(provided_code))</code></p>
      $decoded_pretty
      <h2>CSV match</h2>
      <p>Matches found in CSV: <strong>$(match_count)</strong></p>
      $found_row_html
      $mark_result_html
      $mark_form

      <p style="margin-top:18px; color:#bbb;">If you mark paid, the CSV file <code>$(CSV_FILE)</code> will be updated immediately.</p>
    </div>
    """

    return layout("Check-in result", content)

  catch e
    @error "Admin checkin error" exception=(e, catch_backtrace())
    return layout("Error", "<p>There was an error: $(sprint(showerror,e))</p>")
  end
end

route("/admin/scan") do
  scan_page = raw"""
  <div class="content">
    <h1>Scan QR — Admin scanner</h1>
    <p>Point your phone camera at the QR. The scanner decrypts locally and will automatically check payment status. 
    Border: <span style="font-weight:bold">green = paid, red = not paid / invalid</span>.</p>

    <div style="display:flex; gap:12px; flex-wrap:wrap; align-items:flex-start;">
      <div style="flex:1; min-width:260px;">
        <video id="video" playsinline autoplay style="width:100%; border-radius:8px; border:6px solid #fff; background:#000;"></video>
        <canvas id="canvas" class="hidden" style="display:none;"></canvas>
        <div style="margin-top:8px;">
          <button id="startBtn" style="background:#FFA500;padding:8px 12px;border-radius:6px;border:none;cursor:pointer;">Start camera</button>
          <button id="stopBtn" style="background:#999;padding:8px 12px;border-radius:6px;border:none;cursor:pointer;">Stop</button>
        </div>
      </div>

      <div style="flex:1; min-width:260px;">
        <label><strong>Encrypted code (from QR):</strong></label>
        <textarea id="encrypted" rows="3" style="width:100%; padding:8px; font-family:monospace;" readonly></textarea>

        <label style="margin-top:8px;"><strong>Decrypted fields:</strong></label>
        <div id="decoded" style="background:#111; padding:10px; border-radius:6px; color:#ddd; min-height:88px; white-space:pre-wrap;"></div>

        <div style="margin-top:10px;">
          <button id="copyBtn" style="background:#444;color:white;padding:8px 12px;border-radius:6px;border:none;cursor:pointer;margin-left:8px;">Copy encrypted</button>
        </div>

        <div style="margin-top:8px;">
          <div id="statusBox" style="margin-top:8px; font-weight:bold; font-size:1.05rem;"></div>
        </div>
      </div>
    </div>
  </div>

  <!-- jsQR CDN -->
  <script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>

  <script>
  // Hard-coded valid encrypted codes
  const VALID_CODES = new Set([
    "2dTfw9jakcfQ35Hex9TDx9Tdzc3NzdXQ39LU7tXY39_Uww",
    "2dTfw9jakcfQ35Hex9TDx9Tdzc3NzdXQ39LU"
  ]);

  function xor_decrypt_base64_js(enc, key = 177) {
    if (!enc) return "";
    let s = enc.replace(/-/g, "+").replace(/_/g, "/");
    let pad = (4 - (s.length % 4)) % 4;
    s += "=".repeat(pad);
    let bin = atob(s);
    let bytes = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
    for (let i = 0; i < bytes.length; i++) bytes[i] = bytes[i] ^ key;
    let decoder = new TextDecoder("utf-8");
    return decoder.decode(bytes);
  }

  function escape_html_js(s) {
    return String(s).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/\"/g,"&quot;").replace(/'/g,"&#39;");
  }

  window.addEventListener('DOMContentLoaded', function () {
    const video = document.getElementById('video');
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    const startBtn = document.getElementById('startBtn');
    const stopBtn = document.getElementById('stopBtn');
    const encryptedEl = document.getElementById('encrypted');
    const decodedEl = document.getElementById('decoded');
    const copyBtn = document.getElementById('copyBtn');
    const statusBox = document.getElementById('statusBox');

    let stream = null;
    let scanning = false;
    let scanInterval = null;
    let lastSeen = "";

    async function startCamera() {
      try {
        stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" }, audio: false });
        video.srcObject = stream;
        await video.play();
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        scanning = true;
        scanLoop();
      } catch (e) {
        console.error("Camera access failed:", e && e.message ? e.message : e);
      }
    }

    function stopCamera() {
      scanning = false;
      if (stream) {
        stream.getTracks().forEach(t => t.stop());
        stream = null;
      }
      if (scanInterval) {
        clearTimeout(scanInterval);
        scanInterval = null;
      }
    }

    function handleNewCode(code) {
      encryptedEl.value = code;
      try {
        const dec = xor_decrypt_base64_js(code, 177);
        const parts = dec.split("||");
        decodedEl.innerHTML = "<strong>Full name:</strong> " + escape_html_js(parts[0]||"") +
                              "<br/><strong>Plus-one:</strong> " + escape_html_js(parts[1]||"") +
                              "<br/><strong>Selected package:</strong> " + escape_html_js(parts[2]||"");
      } catch (e) {
        decodedEl.textContent = "Decryption failed";
      }

      // Check directly against hardcoded set
      if (VALID_CODES.has(code)) {
        statusBox.style.color = "lightgreen";
        statusBox.textContent = "PAID ✓";
        document.documentElement.style.border = "8px solid #28a745"; // green
      } else {
        statusBox.style.color = "salmon";
        statusBox.textContent = "NOT PAID ✗";
        document.documentElement.style.border = "8px solid #d9534f"; // red
      }
    }

    function scanLoop() {
      if (!scanning) return;
      try {
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
        let imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        let code = jsQR(imageData.data, imageData.width, imageData.height, { inversionAttempts: "attemptBoth" });
        if (code) {
          if (code.data !== lastSeen) {
            lastSeen = code.data;
            handleNewCode(code.data);
          }
        }
      } catch (e) {
        console.error("scan error", e);
      }
      scanInterval = setTimeout(scanLoop, 300);
    }

    startBtn.addEventListener('click', () => {
      if (!scanning) startCamera();
    });
    stopBtn.addEventListener('click', () => {
      stopCamera();
    });

    copyBtn.addEventListener('click', () => {
      const txt = encryptedEl.value;
      if (!txt) return;
      navigator.clipboard.writeText(txt).then(() => {
        copyBtn.textContent = "Copied!";
        setTimeout(()=> copyBtn.textContent = "Copy encrypted", 1200);
      });
    });

    window.addEventListener('pagehide', () => stopCamera());
  });
  </script>
  """
  layout("Admin scanner", scan_page)
end

# a small set of valid codes
VALID_CODES = Set(["2dTfw9jakcfQ35Hex9TDx9Tdzc3NzdXQ39LU7tXY39_Uww", "2dTfw9jakcfQ35Hex9TDx9Tdzc3NzdXQ39LU"]) 

function check_payment(uniqueCode::AbstractString)
  # Correct boolean check: test membership in the set
  return uniqueCode in VALID_CODES
end

route("/admin/checkstatus", method = POST) do
  code = String(get(params(), :code, "")) |> strip

  decrypted = ""
  decode_success = true
  try
      decrypted = xor_decrypt_base64(code) |> strip
  catch e
      decrypted = "(invalid code)"
      decode_success = false
  end

  # Payment check = always on raw encrypted code
  paid = check_payment(code)

  resp = Dict(
      "ok" => true,                      # ✅ always true unless server crashed
      "paid" => paid,
      "match_count" => paid ? 1 : 0,
      "paymentRef" => paid ? "REF_PLACEHOLDER" : "",
      "decrypted" => decrypted,
      "decode_success" => decode_success # optional extra info
  )

  @info "checkstatus request" code=code decrypted=decrypted paid=paid decode_success=decode_success

  content_type("application/json")
  return JSON.json(resp)
end
 
Genie.config.server_host = "0.0.0.0"   # listen on all interfaces
Genie.config.server_port = 8000        # your chosen port
 

#= Crookerijen lijst: 
1: /crook pagina
2: We CaRe about your Ball(z)
3: Complaints
4: Our Story
5: Full Name e.g. Ne Crook
6: Phone Number
7: Captcha



=#






