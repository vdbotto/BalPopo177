using Genie, Genie.Router, Genie.Renderer.Html

function layout(title, content)
    html("""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>$title</title>
        <style>
            * {
                box-sizing: border-box;
            }
            body {
                margin: 0;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: orange; /* ORANJE ACHTERGROND */
                color: #333;
            }
            header {
                background-color: #222;
                width: 100%;
                padding: 15px 30px;
            }
            nav {
                display: flex;
                gap: 20px;
            }
            nav a {
                color: white;
                text-decoration: none;
                font-weight: bold;
                transition: color 0.2s ease-in-out;
            }
            nav a:hover {
                color: #ffc107;
            }
            .content {
                padding: 40px;
                max-width: 900px;
                margin: 30px auto;
                background-color: white;  /* WIT TEKSTVAK */
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                border-radius: 10px;
            }
            img.sponsor-logo {
                max-width: 300px;
                height: auto;
                margin-top: 20px;
            }
            video#eventvideo {
                max-width: 100%;
                margin-top: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            }
        </style>
    </head>
    <body>
        <header>
            <nav>
                <a href="/">Home</a>
                <a href="/sponsors">Sponsors</a>
                <a href="/inschrijvingen">Inschrijvingen</a>
                <a href="/theevent">The Event</a>
            </nav>
        </header>
        <div class="content">
            $content
        </div>
    </body>
    </html>
    """)
end

route("/") do
    layout("Home", """
        <h1>Welkom op de homepage!</h1>
        <p>XXX XXX XXX XXX XXX.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
    """)
end

route("/sponsors") do 
    layout("Sponsors", """
        <h1>Onze sponsors</h1>
        <ul>
            <li>SEYNTEX</li>
            <li>OIP Sensor Systems</li>
            <li>XXX XXX XXX</li>
        </ul>
        <p>Bekijk hieronder ons sponsorlogo:</p>
        <img src="/static/logo.png" alt="Sponsorlogo" class="sponsor-logo">
    """)
end

route("/inschrijvingen") do 
    layout("Inschrijvingen", """
        <h1>Schrijf je nu in!</h1>
        <p>XXX XXX XXX XXX.</p>
        <p>Vul het formulier in op deze pagina (komt nog).</p>
    """)
end

route("/theevent") do 
    layout("The Event", """
        <h1>Over het evenement</h1>
        <p>Datum: XXX</p>
        <p>Locatie: XXX</p>
        <p>Meer info binnenkort.</p>
        <video id="eventvideo" src="/static/eventvideo.mp4" autoplay muted loop playsinline></video>
    """)
end

up()
