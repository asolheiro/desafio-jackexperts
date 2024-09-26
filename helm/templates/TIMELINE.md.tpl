{{- define "desafio-jackexperts.TIMELINE.MD.tpl" -}}
# Introdução

Esse é um material além da documentação, feito para esclarecer minha linha de raciocínio e trabalho ao desenvolver o projeto e ser um pouco mais subjetivo quanto ao trabalho, contando onde e como consegui as informações.

# 1. Página Web

Como o desafio consiste em hospedar uma página web, optei por montar um HTML simples, com a estilização incluída no próprio *header* para facilitar o *deploy* da página.


## 1.1. Documentação na página web

O único diferencial, além da customização na tentativa de imitar as cores da Jack, foi um pequeno *script* (também incluso no HTML) para ler a documentação no README.md e adicionar na *div* logo abaixo.

Para esse criar esse *script* usei o [zero-md](https://zerodevx.github.io/zero-md/). Adiciono a tag `<script>`, de tipo módulo, importando a biblioteca JS no cabeçalho:
```html
<script type="module">
    import ZeroMd from 'https://cdn.jsdelivr.net/npm/zero-md@3'
    customElements.define('zero-md', ZeroMd)
 </script>
 ```

 Já na `<div>` onde quero adicionar o conteúdo, coloquei:
 ```html
 <zero-md src="./README.md">
    <template>
        <style>
            <!-- estilização específica para o zero-md -->
        </style>
    </template>
</zero-md>
```

    > Nota: O zero-md tem uma porção de templates prontos para uso, mas preferi adicionar as cores manualmente para tentar combinar ao máximo com o resto do projeto.

# 2. [Helm](https://helm.sh/)

O segundo passo foi montar o que será consumido pelo Helm.

## 2.1. Resumo do Helm

De forma resumida o Helm é um gerenciador de pacotes para o Kubernetes que facilita a instalação e o manuseio das aplicações. 

Para funcionar, ele utiliza os ***"charts***", pacotes pré-configurados com os recursos necessários para rodar uma aplicação, tais como deployments, serviços e configurações. 

Com o Helm, a gente pode instalar, atualizar e gerenciar as aplicações no Kubernetes de maneira fácil e rápida, além de permitir que as configuralções possam ser reutilizadas e compartilhadas entre os ambiente e *releases*.

## 2.2. Primeiros passos

Na documentação da ferramenta há diversas formas diferentes de download e instalação, por preferência pessoal e facilidade de instalação sempre busco os *scripts*:
```bash
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
Mas lá há outras maneiras de intalar, como gerenciadores de pacote, direto da fonte e outros.


## 2.3. Helm templates

A grande jogada do Helm é tentar padronizar a forma como organizamos e adicionamos ingress, deployments, configmaps, services e outros objetos dentro de um Cluster Kubernetes; além de facilitar a forma como alteramos dados na estrutura por um todo.

Para isso, iniciamos um projeto com ```helm create <NOME_PROJETO>```. Isso criará uma estrutura como abaixo: 

```markdown
NOME_PROJETO/
├── .helmignore   # Descrição de padrões que serão ignorados no empacotamento
├── Chart.yaml    # Informações sobre o mapeamento que será empacotado
├── values.yaml   # Definição dos valores que serão adicionados ao longo do empacotamento
├── charts/       # Mapeamentos do quais esse mapeamento depende
└── templates/    # Arquivos de templates que serão base para o mapeamento
    └── tests/    # Arquivos de teste
    └── deployment.yaml 
    └── hpa.yaml
    └── ingress.yaml
    └── serviceaccount.yaml  
    └── service.yaml
    └── NOTES.txt
    └── _helpers.tpl
```

Eu, pessoalmente, achei que a estrutura e os arquivos gerados pela ferramenta mais confundiriam do que ajudaram um desenvolvedor de primeira viagem no Helm, então busquei na internet templates simplificados que fizessem sentido para o projeto enxuto que montei.


### 2.3.1 ConfigMap

O desafio pedia especificamente por uma página web customizável regida por um ConfigMap, logo busquei montá-lo em primeiro lugar. 

Ele é um objeto usado para armazenar dados de configuração em pares "chave-valor". Ele permite que eu separe as configurações da aplicação da lógica de execução. Dessa forma, é possível alterar as configurações sem precisar recriar ou modificar a imagem da aplicação. 

As informações armazenadas em um ConfigMap podem ser injetadas nos contêineres como variáveis de ambiente ou montadas como arquivos de configuração. É útil para gerenciar parâmetros, como URLs de serviços externos, chaves de configuração, entre outros, no nosso caso o `index.html` consumido pelo nginx.
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
  labels:
    desafio: jackexperts
data:
  index.html: |
    {{ include "desafio-jackexperts.index.html.tpl" . | indent 4 }}
```

Montamos o arquivo e definimos variáveis, delimitadas pelos dois pares de chaves, os famosos *curly brackets*, que posteriormente serão substituídas na instalação.

A primeira será definida no momento da instalação, já a segunda faz referência à página que vamos exibir. Ela tem a seguinte estrutura:
```yaml
{{ include "<TEMPLATE_NAME>" [CONTEXT] | [INDENTATION] }}
```

Para pode utilizar essa estrutural precisei definir um templater usando a função `define`do helm. Criei um novo arquivo `./templates/index.html.tpl` com o mesmo conteúdo de `index.html`, mas definindo onde o template começa e termina, assim como seu nome:
```html
{{- define "desafio-jackexperts.index.html.tpl" -}}
    <!-- conteúdo de index.html -->
{{- end -}}
```

### 2.3.2. Deployment

O próximo passo no helm foi definir o deployment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
  labels:
    desafio: jackexperts
spec:
  replicas: {{ .Values.replicasCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }} 
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
        desafio: jackexperts
    spec:
      containers:
        - name: nginx
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: 8080
          volumeMounts:
            - name: html-volume
              mountPath: /usr/share/nginx/html
      volumes:
        - name: html-volume
          configMap:
            name: {{ .Release.Name }}-configmap
```

Tudo bem intuitivo, mas vale ressaltar a parte onde tratamos o volume. 

Veja como definimos uma unidade de armazenamento com o nome `html-volume` que herda o conteúdo do nosso ConfigMap escrito acima. Esse volume será montado em `/usr/share/nginx/html`, diretório onde o nginx, por padrão, consome o `index.html` da sua página inicial.


### 2.3.3. Ingress

Em seguida, escrevemos o template responsável por definir o Ingress:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}-ingress
  labels:
    desafio: jackexperts
spec:
  rules:
    - host: nginx.local
      http: 
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: {{ .Release.Name }}-service
              port:
                number: 8080
```

O Ingress é um objeto responsável por definir como será a comunicação "norte-sul" do cluster; ou seja é através dele que definimos as regras para rotear solicitações HTTP(S) externas ao cluster que desejem acessar os serviços.

Para funcionar, o ingress exige que tenhamos um controlador instalado. Nesse caso, usaremos o *"Nginx Ingress Controller"*, o qual pode ser instalado seguindo os passos:
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create namespace ingress-nginx
helm install nginx-ingress \
    ingress-nginx/ingress-nginx \
    --namespace ingress-nginx
```

### 2.3.4. Service

Por último, escrevemos o template relacionado ao services.
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-service
  labels:
    desafio: jackexperts
spec:
  type: {{ .Values.service.type }}
  ports:
  - port: {{ .Values.service.port }}
    targetPort: 8080
  selector:
    app: {{ .Release.Name }}
```

Os valores de cada campo estão descritos no arquivo `values.yaml`, mas aqui definiremos um service to tipo ClusterIp

{{- end -}}
