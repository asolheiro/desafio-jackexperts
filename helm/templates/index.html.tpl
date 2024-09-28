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
                    margin-top: 15;
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

                    .container {
                        border: 1px solid black;
                        padding: 10px;
                    }

                    .content-info {
                        display: none;
                    }

                    .content-doc {
                        display: none;
                    }

                    h2, button {
                      font-size: inherit;
                      line-height: inherit;
                      font-family: inherit;
                    }
                    button {
                      font-family: 'Montserrat', sans-serif;
                      font-weight: bold;
                      padding: 0.5em;
                      background-color: #ffb400;
                      color: #007acc;
                      cursor: pointer;
                      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
                      border-radius: 10px;
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
                    <a href="https://youtu.be/g42GReG3JNo"><img class="list-icons" src="https://www.vectorlogo.zone/logos/youtube/youtube-icon.svg">
                    Vídeo de apresentação</a>
                </p>
            </div>
            <h2>
                <button onclick="toggleContentInfo()">Instruções do desafio</button>
                
            </h2>
            <div class="md-docs container">
            <div class="md-docs content-info">
            <p>
                <b>Objetivo:</b>
                <ul>Aplicação simples com página HTML customizável, definida via Helm e hospedada em um cluster Kubernetes</ul>
            </p>
            <ul>
            <li><strong>Criação</strong></li>
                <ul>
                    <br>
                    <li>Criar um repositório GitHub ou GitLab contendo:</li>
                    <ul>
                        <li>Dockerfile.</li>
                        <li>Arquivos Helm.</li>
                    </ul>
                    <li>Publicar imagem no DockerHub.</li>
                    <li>Aplicar o label "desafio=jackexperts" a todos os objetos.</li>
                </ul>
                <br>
                <li><strong>Configuração</strong></li>
                <ul>
                    <br>
                    <li>Utilizar o ConfigMap para configurar a página web</li>
                    <li>Configurar todos os objetos do kubernetes usando templates helm</li>
                </ul>
                <br>
                <li><strong>Execução</strong></li>
                <ul>
                    <br>
                    <li>Rodar aplicação como usuário não-root</li>
                    <li>Rodar aplicação em um Cluster Kubernetes na Cloud</li>
                    <li>Realizar instalação e atualização dos objetos do cluster através do Helm</li>
                    <li>Apontar um domínio para o cluster</li>
                </ul>
                <br>
                <li><strong>Documentação:</strong></li>
                <ul>
                    <li>Criar uma documentação completa sobre a aplicação, incluindo:</li>
                    <ul>
                        <li>Processo de construção e deploy.</li>
                        <li>Configuração dos arquivos Dockerfile e Helm.</li>
                        <li>Utilizacão de ConfigMaps.</li>
                        <li>Acesso ao domínio da aplicação.</li>
                    </ul>
                </ul>
                <br>
                <li><strong>Vídeo Demonstrativo:</strong></li>
                    <ul>
                        <li>Gravar um vídeo de até 5 minutos apresentando:</li>
                        <ul>
                            <li>A aplicação em funcionamento.</li>
                            <li>Os principais componentes e configurações.</li>
                            <li>Os desafios encontrados e as soluções adotadas.</li>
                        </ul>
                    </ul>
                <br>
                    <br>
                    <li><strong>Diferencial:</strong></li>
                        <ul>
                            <li>Criar um pipeline CI/CD para automatizar o processo de build e deploy.</li>
                            <li>Apresentar a pipeline no vídeo demonstrativo.</li>
                        </ul>
                </ul>
        </div>
        </div>
            <h2>
                <button onclick="toggleContentDoc()">Documentação do projeto:</button>
            </h2>

            <div class="md-docs container">
                <div class="content-doc">
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
                            .md-docs {
                              width: 300px; /* Define a largura da div */
                              padding: 15px;
                              margin: 20px;
                            }
                            
                            .md-docs span {
                              display: block;
                            }

                            pre code {
                              white-space: pre-wrap;
                              word-wrap: break-word;
                              max-width: 800px;

                            }
                        </style>
                    </template>
                </zero-md>
                </div>
            </div>
            <script>
                function toggleContentInfo() {
                    var content = document.querySelector('.content-info');
                    if (content.style.display === 'none') {
                        content.style.display = 'block';
                    } else {
                        content.style.display = 'none';
                    }
                }
                function toggleContentDoc() {
                    var content = document.querySelector('.content-doc');
                    if (content.style.display === 'none') {
                        content.style.display = 'block';
                    } else {
                        content.style.display = 'none';
                    }
                }
            </script>
            <h2>Sugestões e melhorias são muito bem vindas.</h2>
        </body>
        <footer>
            <p>
                &copy; 2024 Armando Solheiro - avgsolheiro@gmail.com
            </p>
        </footer>
    </html>
    {{- end -}}
