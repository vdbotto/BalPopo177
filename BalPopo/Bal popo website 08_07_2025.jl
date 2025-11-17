

# Functie om logo of achtergrondafbeelding als base64 in te laden
function logo_base64_data(path)
    img = load(path)
    buf = IOBuffer()
    ImageMagick.save(Stream(format"PNG", buf), img)
    data = base64encode(take!(buf))
    close(buf)
    return data
end

##### euneune

function background_base64_data(path)
    img = load(path)
    buf = IOBuffer()
    ImageMagick.save(Stream(format"JPG", buf), img)
    data = base64encode(take!(buf))
    close(buf)
    return data
end

# Algemene layout template
function layout(title, content; background_css = "")
    html("""
    <!DOCTYPE html>
    <html lang="nl">
    <head>
        <meta charset="UTF-8" />
        <title>$title</title>
        <style>
            * { box-sizing: border-box; margin: 0; padding: 0; }
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, sans-serif;
                background-color: #111;
                color: #f1f1f1;
                line-height: 1.6;
                $background_css
            }

            header {
                background-color: #000;
                padding: 20px 40px;
                display: flex; justify-content: space-between;
                align-items: center;
                border-bottom: 3px solid #FFA500;
            }
            header h1 { color: #FFA500; font-size: 1.8rem; }

            nav { display: flex; gap: 20px; }
            nav a {
                color: white;
                text-decoration: none;
                font-weight: bold;
                font-size: 1.1rem;
                transition: color 0.2s;
            }
            nav a:hover { color: #FFA500; }

            .hero {
                height: 60vh;
                background-color: #222;
                color: white;
                display: flex;
                flex-direction: column;
                align-items: center; justify-content: center;
                text-align: center;
                background-size: cover; background-position: center;
                position: relative;
            }
            .background-overlay {
                position: absolute;
                top: 0; left: 0;
                width: 100%; height: 100%;
                background: linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)),
                            url('path/to/your/background.jpg');
                background-size: cover;
                background-position: center;
                z-index: 0;
            }

            .hero h2 { font-size: 3em; margin-bottom: 10px; }
            .hero p { font-size: 1.3em; color: #ccc; }

            .content {
                position: relative; z-index: 1;
                padding: 60px 20px;
                max-width: 1000px;
                margin: 60px auto;
                background-color: #1a1a1a;
                border-radius: 12px;
                box-shadow: 0 8px 16px rgba(0,0,0,0.4);
            }
            h1,h2,h3 { color: #FFA500; }
            p { color: #eee; }
            footer {
                background-color: #111;
                color: #ccc;
                text-align: center;
                padding: 20px;
                font-size: 0.9em;
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

            button.call-action {
                display: inline-block;
                background: #FFA500;
                color: #111;
                border: none;
                padding: 15px 30px;
                font-size: 1.1rem;
                border-radius: 5px;
                cursor: pointer;
                transition: background 0.2s;
            }
            button.call-action:hover {
                background: #e69500;
            }

            video#eventvideo {
                width: 100%;
                margin-top: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(255,165,0,0.2);
            }
        </style>
        <script>
            const origTitle = document.title;
            document.addEventListener("visibilitychange", () => {
              document.title = document.hidden ? "Kom terug!" : origTitle;
            });
        </script>
    </head>
    <body>
        <header>
            <h1>Ball Polytechnic</h1>
            <nav>
                <a href="/">Home</a>
                <a href="/sponsors">Sponsors</a>
                <a href="/inschrijvingen">Inschrijvingen</a>
                <a href="/theevent">The Event</a>
                <a href="ourstory">Our Story</a>
            </nav>
        </header>

        $content

        <footer>
            Bal Popo 177 —
            <a href="/legal">Legal</a> |
            <a href="/contact">Contact</a> | Website written in:
            <a href="https://julialang.org">Julia</a> |
            <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Complaints</a>
        </footer>
    </body>
    </html>
    """)
end

# Routes
route("/crook") do
    layout("Neyt", """
        <div class="hero">
            <div class="background-overlay"></div>
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
    bg = background_base64_data("C:/Users/otto.vandenbergh@mil.be/OneDrive - Belgian Defence/Site_Bal_Popo/BalPopo/static/background.jpg")
    hero_block = """
        <div class="hero">
            <div class="background-overlay" style="background-image: url('data:image/jpeg;base64,$bg')"></div>
            <h2>Welkom</h2>
            <p>Ball Polytechnic 177</p>
        </div>
    """
    main_content = """
        <div class="content">
            <h2>177 X</h2>
            <p>Known as the biggest crooks in the RMA</p>
            <h2>Praktische informatie</h2>
            <p>📅 DTG: 131800FEB25<br>📍 Locatie: NATO cosmic top secret<br>🎟️ Tickets: Not yet for sale</p>
            <button class="call-action" onclick="location.href='/theevent'">Meer info</button>
        </div>
    """
    layout("Home", hero_block * main_content)
end

route("/sponsors") do
    data1 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/LogoSeyntex.png")
    data2 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/LogoOIP.png")
    content = """
      <div class="content">
        <h1>Onze sponsors</h1>
        <p>Zoals elk jaar kon de organisatie van Bal Popo rekenen op de uitgebreide steun van verschillende sponsors. Zonder hen was de organisatie van dit bal niet mogelijk. Hier moet nog wat saus komen. </p>

        <div class="sponsor-section">
          <h2>Goud</h2>
          <div class="sponsor-tier">
            <em>Niemand (voorlopig!)</em>
          </div>

          <h2>Zilver</h2>
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

          <h2>Brons</h2>
          <div class="sponsor-tier sponsor-cards">
            <div class="sponsor-card">
              <a href="https://www.baesystems.com" target="_blank">
                <strong style="color:#000">BAE Systems</strong><br>
                <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/BAE_Systems_logo.svg/1024px-BAE_Systems_logo.svg.png" alt="BAE logo" class="sponsor-logo">
              </a>
            </div>
          </div>
        </div>
      </div>

      <style>
        .sponsor-section { text-align: center; padding: 40px; color: #f0f0f0; }
        .sponsor-section h2 { font-size: 2em; color: #fff; margin-top: 40px; }
        .sponsor-tier { margin-bottom: 20px; }
        .sponsor-cards {
          display: flex; justify-content: center;
          flex-wrap: wrap; gap: 40px; margin-top: 20px;
        }
        .sponsor-card {
          background: #fff; border-radius: 12px;
          padding: 30px; max-width: 260px;
          text-align: center; transition: transform 0.2s;
          box-shadow: 0 6px 16px rgba(0,0,0,0.12);
        }
        .sponsor-card:hover { transform: scale(1.05); }
        .sponsor-logo { max-width: 180px; height: auto; margin-top: 12px; }
      </style>
    """
    layout("Sponsors", content)
end

route("/contact") do
    content = """
      <div class="content">
        <h1>Contact</h1>
        <p>Heb je algemene vragen over Bal Popo? Neem gerust contact op via e-mail:</p>
        <p><a href="mailto:bal@177pol.rma.ac.be">bal@177pol.rma.ac.be</a></p>

        <p>Vragen over sponsoring? Richt je dan tot:</p>
        <p><a href="mailto:sponsors@177pol.rma.ac.be">sponsors@177pol.rma.ac.be</a></p>

        <p>Locatie van de feitelijke vereniging:</p>
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

route("/inschrijvingen") do
    content = """
      <div class="content">
        <h1>Inschrijvingen</h1>
        <p>Het formulier komt binnenkort online.</p>
      </div>
    """
    layout("Inschrijvingen", content)
end

route("/theevent") do
    content = """
      <div class="hero">
        <div class="background-overlay"></div>
        <h2>The Event</h2>
      </div>
      <div class="content">
        <h1>Over het evenement</h1>
        <p>Datum: XXX</p>
        <p>Locatie: XXX</p>
        <p>Meer info binnenkort.</p>
        <video id="eventvideo" src="/static/eventvideo.mp4" autoplay muted loop playsinline></video>
      </div>
    """
    layout("The Event", content)
end

route("/legal") do
    content = """
      <div class="content">
        <h1>Wettelijke informatie</h1>
        <p>Bal Popo 177 is een feitelijke vereniging die tot doel heeft dit bal te organiseren, dat zal plaatsvinden op 13 februari 2025. De vereniging heeft geen winstoogmerk, wat betekent dat alle middelen die na het bal niet besteed zijn, gestord zullen worden aan verschillende goede doelen. 
        Hoewel de feitelijke vereniging niet in het bezit is van een BTW-nummer, zijn de sponsorbedragen in België 100% fiscaal aftrekbaar. Dit moet nog herschreven worden uiteraard. </p>
      </div>
    """
    layout("Legal", content)
end

route("/ourstory") do
    # Laad afbeeldingen als base64
    img1 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/story1.jpeg")
    img2 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/story2.jpeg")
    img3 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/story3.jpeg")
    img4 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/Rodeo.jpg")
    img5 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/Paintball1Ba.jpg")
    img6 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/Budapest2.jpg")
    img7 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/Frigate2.jpg")
    img8 = logo_base64_data("C:/Users/Henrik/Desktop/BalPopo/static/Felix1.jpg")

    content = """
      <div class="content">
        <h1>DECET IMPERATOREM STANTEM MORI</h1>
        <p>With it's 27 members, 177 is the biggest -unfiltered- promotion POL in the RMA. It also happens to be the most fun one. </p>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img1" alt="Afbeelding 1">
          <p class="caption">177 after giving birth to 179</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img2" alt="Afbeelding 2">
          <p class="caption">The 177-frigate with it's 40mm-cannon</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img3" alt="Afbeelding 3">
          <p class="caption">The mighty lynx</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img4" alt="Afbeelding 4">
          <p class="caption">The end of 3Ba january exams (1 person)</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img5" alt="Afbeelding 5">
          <p class="caption">The first cohesion activity, back when 177 counted more than 40 effectives</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img6" alt="Afbeelding 6">
          <p class="caption">177's first international adventure</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img7" alt="Afbeelding 6">
          <p class="caption">The frigate at it's maximum capacity</p>
        </div>

        <div class="story-block">
          <img src="data:image/jpeg;base64,$img8" alt="Afbeelding 6">
          <p class="caption">Cooldown after sports class</p>
        </div>

        <p>Lorem Ipsum</p>
      </div>

      <style>
        .story-block {
          margin: 40px 0;
          text-align: center;
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
    """

    layout("Our story", content)
end
