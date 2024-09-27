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
                    a {
                        text-decoration: none;
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
                    color: #cdd6f4
                    }
            </style>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
            <link rel="icon" href="./favicon.ico" type="image/x-icon">
            <script type="module">
                import ZeroMd from 'https://cdn.jsdelivr.net/npm/zero-md@3'
                customElements.define('zero-md', ZeroMd)
            </script>
                <title>Desafio - Jack Experts</title>
        </head>
        <body>
            <p>
                <h1>Bem-vindo à minha solução!</h1>
            </p>
            <div class="main">
                <h3>Links para os elementos da solução:</h3>
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
                Instruções do desafio
            </h2>
            <div class="md-docs">
                <ul>
                <li><strong>Criação e Configuração:</li>
                    <ul>
                        <li>Criar um repositório Git contendo:</li>
                        <ul>
                            <li>Dockerfile: Define a imagem do Docker para a aplicação.</li>
                            <li>Arquivos Helm: Descrevem os recursos Kubernetes para a aplicação.</li>
                        </ul>
                        <li>Construir a imagem Docker e publicá-la no Docker Hub.</li>
                        <li>Configurar a aplicação para não rodar como root.</li>
                        <li>Utilizar ConfigMaps para customizar a página web.</li>
                        <li>Definir todos os objetos Kubernetes utilizando Helm.</li>
                        <li>Associar um domínio à aplicação.</li>
                        <li>Aplicar o label `desafio=jackexperts` a todos os objetos.</li>
                    </ul>
                    <li><strong>Documentação:</li>
                    <ul>
                        <li>Criar uma documentação completa sobre a aplicação, incluindo:</li>
                        <ul>
                            <li>Processo de construção e deploy.</li>
                            <li>Configuração dos arquivos Dockerfile e Helm.</li>
                            <li>Utilizacão de ConfigMaps.</li>
                            <li>Acesso ao domínio da aplicação.</li>
                        </ul>
                    </ul>
                    <li><strong>Vídeo Demonstrativo:</li>
                        <ul>
                            <li>Gravar um vídeo de até 5 minutos apresentando:</li>
                            <ul>
                                <li>A aplicação em funcionamento.</li>
                                <li>Os principais componentes e configurações.</li>
                                <li>Os desafios encontrados e as soluções adotadas.</li>
                            </ul>
                        </ul>
                        <li><strong>Entrega:</li>
                            <ul>
                                <li>Enviar o repositório Git e o link do vídeo para ruan@jackexperts.com.</li>
                                <li>Utilizar os usuários GitLab/GitHub ruan.oliveira.</li>
                                <li>Prazo de entrega: 27/09.</li>
                            </ul>
                            <li><strong>Diferencial:</li>
                                <ul>
                                    <li>Criar um pipeline CI/CD para automatizar o processo de build e deploy.</li>
                                    <li>Apresentar a pipeline no vídeo demonstrativo.</li>
                                </ul>
                    </ul>
            </div>
            <h2>
                Documentação do projeto:
            </h2>
            <div class="md-docs">
                <script type="module">
                    import ZeroMd from 'https://cdn.jsdelivr.net/npm/zero-md@3'
                 </script>                 
                 
                <zero-md src="https://br-ne1.magaluobjects.com/juris-public-files-to-download/armando/README.md">
                    <template>
                        <style>
                            body {
                                background-color: #ffb400;
                                border-radius: 10px;
                                padding: 15px;
                                margin: 20px;
                                color: #cdd6f4
                            }
                            a {
                                color: #f5c2e7;
                                font-weight: semi-bold;
                                text-decoration: none;
                            }
                            code {
                                color: #94e2d5;
                            }
                        </style>
                    </template>
                </zero-md>
            </div>
            <h2>Sugestões e melhorias são muito bem vindas.</h2>
        </body>
        <footer>
            <p>
                &copy; 2024 Armando Solheiro - avgsolheiro@gmail.com
            </p>
        </footer>
    </html>
    {{- end -}}
