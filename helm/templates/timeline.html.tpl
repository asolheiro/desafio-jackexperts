{{- define "desafio-jacexperts.timeline.html.tpl" -}}
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <style>
      body { 
        background-color: #2d2d30
      }
      h1, h2, h3 {
          color: #89b4fa;
      }
      
      p {
        color: #cdd6f4;
      }
      code {
        color: #a6e3a1;
      }
      a {
        color: #f5e0dc;
      }
    </style>  
  </head>
  <body>
    
    <h1 id="intro">Introdução</h1>
      <p>Esse é um material além da documentação, feito para esclarecer minha linha de raciocínio e trabalho ao desenvolver o projeto e ser um pouco mais subjetivo quanto ao trabalho, contando onde e como consegui as informações.</p>
    <h1 >1. Página Web</h1>
      <p>Como o desafio consiste em hospedar uma página web, optei por montar um HTML simples, com a estilização incluída no próprio <em>header</em> para facilitar o <em>deploy</em> da página.</p>
      <h2 id="1-1-documenta-o-na-p-gina-web">1.1. Documentação na página web</h2>
        <p>O único diferencial, além da customização na tentativa de imitar as cores da Jack, foi um pequeno <em>script</em> (também incluso no HTML) para ler a documentação no README.md e adicionar na <em>div</em> logo abaixo.</p>
        <p>Para esse criar esse <em>script</em> usei o <a href="https://zerodevx.github.io/zero-md/">zero-md</a>. Adiciono a tag <code>&lt;script&gt;</code>, de tipo módulo, importando a biblioteca JS no cabeçalho:</p>
        <pre><code class="lang-html"><span class="hljs-tag">&lt;<span class="hljs-name">script</span> <span class="hljs-attr">type</span>=<span class="hljs-string">"module"</span>&gt;</span><span class="javascript">
      <span class="hljs-keyword">import</span> ZeroMd <span class="hljs-keyword">from</span> <span class="hljs-string">'https://cdn.jsdelivr.net/npm/zero-md@3'</span>
      customElements.define(<span class="hljs-string">'zero-md'</span>, ZeroMd)
  </span><span class="hljs-tag">&lt;/<span class="hljs-name">script</span>&gt;</span>
  </code></pre>
  <p> Já na <code>&lt;div&gt;</code> onde quero adicionar o conteúdo, coloquei:</p>
  <pre><code class="lang-html"> <span class="hljs-tag">&lt;<span class="hljs-name">zero-md</span> <span class="hljs-attr">src</span>=<span class="hljs-string">"./README.md"</span>&gt;</span>
      <span class="hljs-tag">&lt;<span class="hljs-name">template</span>&gt;</span>
          <span class="hljs-tag">&lt;<span class="hljs-name">style</span>&gt;</span><span class="xml">
              <span class="hljs-comment">&lt;!-- estilização específica para o zero-md --&gt;</span>
          </span><span class="hljs-tag">&lt;/<span class="hljs-name">style</span>&gt;</span>
      <span class="hljs-tag">&lt;/<span class="hljs-name">template</span>&gt;</span>
  <span class="hljs-tag">&lt;/<span class="hljs-name">zero-md</span>&gt;</span>
  </code></pre>
  <pre><code>&gt; Not<span class="hljs-variable">a:</span> O zero-md tem uma porçã<span class="hljs-keyword">o</span> de templates prontos para uso, mas preferi adicionar <span class="hljs-keyword">as</span> cores manualmente para tentar combinar ao <span class="hljs-keyword">m</span>áximo <span class="hljs-keyword">com</span> <span class="hljs-keyword">o</span> resto <span class="hljs-keyword">do</span> projeto.
  </code></pre><h1 id="2-helm-https-helm-sh-">2. <a href="https://helm.sh/">Helm</a></h1>
  <p>O segundo passo foi montar o que será consumido pelo Helm.</p>
  <h2 id="2-1-resumo-do-helm">2.1. Resumo do Helm</h2>
  <p>De forma resumida o Helm é um gerenciador de pacotes para o Kubernetes que facilita a instalação e o manuseio das aplicações. </p>
  <p>Para funcionar, ele utiliza os <strong><em>&quot;charts</em></strong>&quot;, pacotes pré-configurados com os recursos necessários para rodar uma aplicação, tais como deployments, serviços e configurações. </p>
  <p>Com o Helm, a gente pode instalar, atualizar e gerenciar as aplicações no Kubernetes de maneira fácil e rápida, além de permitir que as configuralções possam ser reutilizadas e compartilhadas entre os ambiente e <em>releases</em>.</p>
  <h2 id="2-2-primeiros-passos">2.2. Primeiros passos</h2>
  <p>Na documentação da ferramenta há diversas formas diferentes de download e instalação, por preferência pessoal e facilidade de instalação sempre busco os <em>scripts</em>:</p>
  <pre><code class="lang-bash">$ <span class="hljs-string">curl </span>-<span class="hljs-string">fsSL </span>-o <span class="hljs-string">get_helm.</span><span class="hljs-string">sh </span><span class="hljs-string">https:</span>//<span class="hljs-string">raw.</span><span class="hljs-string">githubusercontent.</span><span class="hljs-string">com/</span><span class="hljs-string">helm/</span><span class="hljs-string">helm/</span><span class="hljs-string">main/</span><span class="hljs-string">scripts/</span><span class="hljs-built_in">get-helm-3</span>
  $ <span class="hljs-string">chmod </span><span class="hljs-string">700 </span><span class="hljs-string">get_helm.</span><span class="hljs-string">sh
  </span>$ ./<span class="hljs-string">get_helm.</span><span class="hljs-string">sh</span>
  </code></pre>
  <p>Mas lá há outras maneiras de intalar, como gerenciadores de pacote, direto da fonte e outros.</p>
  <h2 id="2-3-helm-templates">2.3. Helm templates</h2>
  <p>A grande jogada do Helm é tentar padronizar a forma como organizamos e adicionamos ingress, deployments, configmaps, services e outros objetos dentro de um Cluster Kubernetes; além de facilitar a forma como alteramos dados na estrutura por um todo.</p>
  <p>Para isso, iniciamos um projeto com <code>helm create &lt;NOME_PROJETO&gt;</code>. Isso criará uma estrutura como abaixo: </p>
  <pre><code class="lang-markdown">NOME_PROJETO/
  ├── .helmignore   # <span class="hljs-keyword">Descri</span>ção <span class="hljs-keyword">de</span> padrões <span class="hljs-keyword">que</span> serão ignorados <span class="hljs-keyword">no</span> empacotamento
  ├── Chart.yaml    # Informações sobre o mapeamento <span class="hljs-keyword">que</span> será empacotado
  ├── values.yaml   # Definição dos valores <span class="hljs-keyword">que</span> serão adicionados ao longo <span class="hljs-keyword">do</span> empacotamento
  ├── charts/       # Mapeamentos <span class="hljs-keyword">do</span> quais esse mapeamento depende
  └── templates/    # Arquivos <span class="hljs-keyword">de</span> templates <span class="hljs-keyword">que</span> serão base para o mapeamento
      └── tests/    # Arquivos <span class="hljs-keyword">de</span> teste
      └── deployment.yaml 
      └── hpa.yaml
      └── ingress.yaml
      └── serviceaccount.yaml  
      └── service.yaml
      └── <span class="hljs-keyword">NOTES</span>.txt
      └── _helpers.tpl
  </code></pre>
  <p>Eu, pessoalmente, achei que a estrutura e os arquivos gerados pela ferramenta mais confundiriam do que ajudaram um desenvolvedor de primeira viagem no Helm, então busquei na internet templates simplificados que fizessem sentido para o projeto enxuto que montei.</p>
  <h3 id="2-3-1-configmap">2.3.1 ConfigMap</h3>
  <p>O desafio pedia especificamente por uma página web customizável regida por um ConfigMap, logo busquei montá-lo em primeiro lugar. </p>
  <p>Ele é um objeto usado para armazenar dados de configuração em pares &quot;chave-valor&quot;. Ele permite que eu separe as configurações da aplicação da lógica de execução. Dessa forma, é possível alterar as configurações sem precisar recriar ou modificar a imagem da aplicação. </p>
  <p>As informações armazenadas em um ConfigMap podem ser injetadas nos contêineres como variáveis de ambiente ou montadas como arquivos de configuração. É útil para gerenciar parâmetros, como URLs de serviços externos, chaves de configuração, entre outros, no nosso caso o <code>index.html</code> consumido pelo nginx.</p>
  <pre><code class="lang-yaml"><span class="hljs-symbol">apiVersion:</span> v1
  <span class="hljs-symbol">kind:</span> ConfigMap
  <span class="hljs-symbol">metadata:</span>
  <span class="hljs-symbol">  name:</span> {{ .Release.Name }}-configmap
  <span class="hljs-symbol">  labels:</span>
  <span class="hljs-symbol">    desafio:</span> jackexperts
  <span class="hljs-symbol">data:</span>
    index.html: |
      {{ include <span class="hljs-string">"desafio-jackexperts.index.html.tpl"</span> . | indent <span class="hljs-number">4</span> }}
  </code></pre>
  <p>Montamos o arquivo e definimos variáveis, delimitadas pelos dois pares de chaves {{...}}, que posteriormente serão substituídas na instalação.</p>
  <p>A primeira será definida no momento da instalação, já a segunda faz referência à página que vamos exibir. Ela tem a seguinte estrutura:</p>
  <pre><code class="lang-yaml">{{ include <span class="hljs-string">"&lt;TEMPLATE_NAME&gt;"</span> [CONTEXT] | [INDENTATION] }}
  </code></pre>
  <p>Para pode utilizar essa estrutural precisei definir um templater usando a função <code>define</code>do helm. Criei um novo arquivo <code>./templates/index.html.tpl</code> com o mesmo conteúdo de <code>index.html</code>, mas definindo onde o template começa e termina, assim como seu nome:</p>
  <pre><code class="lang-html"><span class="xml"></span><span class="hljs-template-variable">{{- define "desafio-jackexperts.index.html.tpl" -}}</span><span class="xml">
      <span class="hljs-comment">&lt;!-- conteúdo de index.html --&gt;</span>
  </span><span class="hljs-template-variable">{{- end -}}</span><span class="xml"></span>
  </code></pre>
  <h3 id="2-3-2-deployment">2.3.2. Deployment</h3>
  <p>O próximo passo no helm foi definir o deployment:</p>
  <pre><code class="lang-yaml"><span class="hljs-attr">apiVersion:</span> apps/v1
  <span class="hljs-attr">kind:</span> Deployment
  <span class="hljs-attr">metadata:</span>
  <span class="hljs-attr">  name:</span> {{ .Release.Name }}-deployment
  <span class="hljs-attr">  labels:</span>
  <span class="hljs-attr">    desafio:</span> jackexperts
  <span class="hljs-attr">spec:</span>
  <span class="hljs-attr">  replicas:</span> {{ .Values.replicasCount }}
  <span class="hljs-attr">  selector:</span>
  <span class="hljs-attr">    matchLabels:</span>
  <span class="hljs-attr">      app:</span> {{ .Release.Name }} 
  <span class="hljs-attr">  template:</span>
  <span class="hljs-attr">    metadata:</span>
  <span class="hljs-attr">      labels:</span>
  <span class="hljs-attr">        app:</span> {{ .Release.Name }}
  <span class="hljs-attr">        desafio:</span> jackexperts
  <span class="hljs-attr">    spec:</span>
  <span class="hljs-attr">      containers:</span>
  <span class="hljs-attr">        - name:</span> nginx
  <span class="hljs-attr">          image:</span> <span class="hljs-string">"<span class="hljs-template-variable">{{ .Values.image.repository }}</span>:<span class="hljs-template-variable">{{ .Values.image.tag }}</span>"</span>
  <span class="hljs-attr">          ports:</span>
  <span class="hljs-attr">            - containerPort:</span> <span class="hljs-number">8080</span>
  <span class="hljs-attr">          volumeMounts:</span>
  <span class="hljs-attr">            - name:</span> html-volume
  <span class="hljs-attr">              mountPath:</span> /usr/share/nginx/html
  <span class="hljs-attr">      volumes:</span>
  <span class="hljs-attr">        - name:</span> html-volume
  <span class="hljs-attr">          configMap:</span>
  <span class="hljs-attr">            name:</span> {{ .Release.Name }}-configmap
  </code></pre>
  <p>Tudo bem intuitivo, mas vale ressaltar a parte onde tratamos o volume. </p>
  <p>Veja como definimos uma unidade de armazenamento com o nome <code>html-volume</code> que herda o conteúdo do nosso ConfigMap escrito acima. Esse volume será montado em <code>/usr/share/nginx/html</code>, diretório onde o nginx, por padrão, consome o <code>index.html</code> da sua página inicial.</p>
  <h3 id="2-3-3-ingress">2.3.3. Ingress</h3>
  <p>Em seguida, escrevemos o template responsável por definir o Ingress:</p>
  <pre><code class="lang-yaml"><span class="hljs-attr">apiVersion:</span> networking.k8s.io/v1
  <span class="hljs-attr">kind:</span> Ingress
  <span class="hljs-attr">metadata:</span>
  <span class="hljs-attr">  name:</span> {{ .Release.Name }}-ingress
  <span class="hljs-attr">  labels:</span>
  <span class="hljs-attr">    desafio:</span> jackexperts
  <span class="hljs-attr">spec:</span>
  <span class="hljs-attr">  rules:</span>
  <span class="hljs-attr">    - host:</span> nginx.local
  <span class="hljs-attr">      http:</span> 
  <span class="hljs-attr">        paths:</span>
  <span class="hljs-attr">        - path:</span> /
  <span class="hljs-attr">          pathType:</span> Prefix
  <span class="hljs-attr">          backend:</span>
  <span class="hljs-attr">            service:</span>
  <span class="hljs-attr">              name:</span> {{ .Release.Name }}-service
  <span class="hljs-attr">              port:</span>
  <span class="hljs-attr">                number:</span> <span class="hljs-number">8080</span>
  </code></pre>
  <p>O Ingress é um objeto responsável por definir como será a comunicação &quot;norte-sul&quot; do cluster; ou seja é através dele que definimos as regras para rotear solicitações HTTP(S) externas ao cluster que desejem acessar os serviços.</p>
  <p>Para funcionar, o ingress exige que tenhamos um controlador instalado. Nesse caso, usaremos o <em>&quot;Nginx Ingress Controller&quot;</em>, o qual pode ser instalado seguindo os passos:</p>
  <pre><code class="lang-bash">helm repo <span class="hljs-keyword">add</span> ingress-nginx https:<span class="hljs-comment">//kubernetes.github.io/ingress-nginx</span>
  helm repo update
  kubectl <span class="hljs-keyword">create</span> <span class="hljs-keyword">namespace</span> ingress-nginx
  helm install nginx-ingress \
      ingress-nginx/ingress-nginx \
      --<span class="hljs-keyword">namespace</span> ingress-nginx
  </code></pre>
  <h3 id="2-3-4-service">2.3.4. Service</h3>
  <p>Por último, escrevemos o template relacionado ao services.</p>
  <pre><code class="lang-yaml">apiVersion: v1
  kind: Service
  metadata:
    name: {{ <span class="hljs-selector-class">.Release</span><span class="hljs-selector-class">.Name</span> }}-service
    labels:
      desafio: jackexperts
  spec:
    type: {{ <span class="hljs-selector-class">.Values</span><span class="hljs-selector-class">.service</span><span class="hljs-selector-class">.type</span> }}
    ports:
    - port: {{ <span class="hljs-selector-class">.Values</span><span class="hljs-selector-class">.service</span><span class="hljs-selector-class">.port</span> }}
      targetPort: <span class="hljs-number">8080</span>
    selector:
      app: {{ <span class="hljs-selector-class">.Release</span><span class="hljs-selector-class">.Name</span> }}
  </code></pre>
  <p>Os valores de cada campo estão descritos no arquivo <code>values.yaml</code>, mas aqui definiremos um service to tipo ClusterIp</p>
  </body>
</html>
{{- end -}}