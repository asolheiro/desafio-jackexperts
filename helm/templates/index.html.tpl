    {{- define "desafio-jackexperts.index.html.tpl" -}}
    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body {
        background-color: #2d2d30;
        font-family: 'Montserrat', sans-serif; 
        }
        h1 {
        text-align: center;
        margin: 0 auto;
        color: #007acc;
        font-weight: bolder;
        }

        h2 {
        color: #007acc;
        font-weight: 400;
        margin: 0 auto;
        text-align: center;
        }

        h3 {
        margin-top: 50;
        margin-left: 15;
        color: #007acc;
        }

        footer {
        display: flex;
        justify-content: space-between;
        text-align: center;
        padding: 20px;
        color: #e1e8ed;
        }

        .main {
        text-align: center;
        margin: 20px;
        background-color: #ffb400;
        border-radius: 10px;
        padding: 15px;
        }

        .list-icons {
        width: 20px;
        height: 20px;
        margin-right: 10px;

        }

        .items {
        display: flex;
        align-items: center;
        justify-content: center;
        }

        .md-docs {
        background-color: #181825;
        border-radius: 10px;
        padding: 15px;
        margin: 20px;
        }
        </style>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
        <link rel="icon" href="./favicon.ico" type "image/x-icon">
        <title>Desafio - Jack Experts</title>
        <script type="module">
        import ZeroMd from 'https://cdn.jsdelivr.net/npm/zero-md@3'
        customElements.define('zero-md', ZeroMd)
        </script>
        </head>
        <body>
            <p>
                <h1>Bem-vindo à minha solução!</h1>
                <h2>Sugestões e melhorias são muito bem vindas.</h2>
            </p>
            <div class="main">
                <h3> Links para os elementos da solução:</h3>
                <p class="items">
                    <a href="https://hub.docker.com/repository/docker/asolheiro/desafio-jackexperts/general"><img class="list-icons" src="https://www.vectorlogo.zone/logos/docker/docker-tile.svg">
                    Imagem no DockerHub</a>
                </p>
                <p class="items">
                    <a href="https://github.com/asolheiro/desafio-jackexperts"><img class="list-icons" src="https://www.vectorlogo.zone/logos/github/github-tile.svg">
                    Repositório no GitHub </a>
                </p>
                <p class="items">
                    <a href="https://youtube.com/XXXXXXXXXXXXXXX"><img class="list-icons" src="https://www.vectorlogo.zone/logos/youtube/youtube-icon.svg">
                    Vídeo de apresentação</a>
                </p>
            </div>
            <h2>
                Documentação do projeto:
            </h2>
            <div class="md-docs">
                    <script type="module">
                        import ZeroMd from 'https://cdn.jsdelivr.net/npm/zero-md@3'
                        customElements.define('zero-md', ZeroMd)
                     </script>                 
                     
                    <zero-md src="./timeline.md">
                        <template>
                            <style>
                                body {
                                    background-color: #ffb400;
                                }
                            </style>
                        </template>
                    </zero-md>
            </div>
        </body>
        <footer>
            <p>
                &copy; 2024 Armando Solheiro - avgsolheiro@gmail.com
            </p>
        </footer>
    </html>
{{- end -}}