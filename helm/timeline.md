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

# 2. Nginx

Para consumir esse `index.html` teremos um Nginx na porta 8080. O Dockerfile que criei para descrevê-lo está abaixo:

```Dockerfile
FROM nginx:alpine

ARG USER_ID=1001
ARG GROUP_ID=1001

RUN addgroup -g ${GROUP_ID} desafio-jackexperts && \
    adduser -D -u ${USER_ID} -G desafio-jackexperts desafio-jackexperts

COPY ./custom_nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/cache/nginx /var/run /var/log/nginx /var/temp/nginx && \
    chown -R desafio-jackexperts /var/cache/nginx /var/run /var/log/nginx /var/temp/nginx

RUN chown -R desafio-jackexperts /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

USER desafio-jackexperts

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;"]
```


# 3. [Helm](https://helm.sh/)

O segundo passo foi montar o que será consumido pelo Helm.

## 3.1. Resumo do Helm

De forma resumida o Helm é um gerenciador de pacotes para o Kubernetes que facilita a instalação e o manuseio das aplicações. 

Para funcionar, ele utiliza os ***"charts***", pacotes pré-configurados com os recursos necessários para rodar uma aplicação, tais como deployments, serviços e configurações. 

Com o Helm, a gente pode instalar, atualizar e gerenciar as aplicações no Kubernetes de maneira fácil e rápida, além de permitir que as configuralções possam ser reutilizadas e compartilhadas entre os ambiente e *releases*.

## 3.2. Primeiros passos

Na documentação da ferramenta há diversas formas diferentes de download e instalação, por preferência pessoal e facilidade de instalação sempre busco os *scripts*:
```bash
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
Mas lá há outras maneiras de instalar, como gerenciadores de pacote, direto da fonte e outros.


## 3.3. Helm templates

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


### 3.3.1 ConfigMap

O desafio pedia especificamente por uma página web customizável regida por um ConfigMap, logo busquei montá-lo em primeiro lugar. 

Ele é um objeto usado para armazenar dados de configuração em pares "chave-valor". Ele permite que eu separe as configurações da aplicação da lógica de execução. Dessa forma, é possível alterar as configurações sem precisar recriar ou modificar a imagem da aplicação. 

As informações armazenadas em um ConfigMap podem ser injetadas nos contêineres como variáveis de ambiente ou montadas como arquivos de configuração. É útil para gerenciar parâmetros, como URLs de serviços externos, chaves de configuração, entre outros, no nosso caso o `index.html` consumido pelo nginx.
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
  namespace: {{ .Values.namespace }}
  labels:
    desafio: jackexperts
    app: nginx
data:
  index.html: |
    {{ include "desafio-jackexperts.index.html.tpl" . | indent 4 }}
```

Montamos o arquivo e definimos variáveis, delimitadas pelos dois pares de chaves {{...}}, que posteriormente serão substituídas na instalação.

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

### 3.3.2. Deployment

O próximo passo no helm foi definir o deployment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
  namespace: {{ .Values.namespace }}
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
      securityContext:
        fsGroup: {{ .Values.securityContext.runAsGroup }}
      containers:
        - name: nginx
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: 8080
          securityContext:
            runAsUser: {{ .Values.securityContext.runAsUser }}
            runAsGroup: {{ .Values.securityContext.runAsGroup }}
            allowPrivilegeEscalation: {{ .Values.securityContext.allowPrivilegeEscalation }}
          volumeMounts:
            - name: html-volume
              mountPath: /usr/share/nginx/html
      volumes:
        - name: html-volume
          configMap:
            name: {{ .Release.Name }}-configmap
```
Esse é o objetivo responsável por descrever como será a execução da imagem que criamos para o para o nginx, especificada no campo `spec.spec.containers[0].image`. Tanto é, que logo abaixo, em `spec.spec.containers[0].securityContext` passamos os valores que usamos para criar o usuário no contêiner.

Também, veja como definimos uma unidade de armazenamento com o nome `html-volume` que herda o conteúdo do nosso ConfigMap escrito acima. Esse volume será montado em `/usr/share/nginx/html`, diretório onde o nginx, por padrão, consome o `index.html` da sua página inicial.

Fora isso, tudo bem intuitivo. 


### 3.3.3. Ingress

Em seguida, escrevemos o template responsável por definir o Ingress:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}-ingress
  namespace: {{ .Values.namespace }}
  labels:
    desafio: jackexperts
spec:
  rules:
    - host: {{ .Values.ingress.domain }}
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

O Ingress é um objeto responsável por definir como será a comunicação "norte-sul" do cluster; ou seja é através dele que definimos as regras para rotear solicitações HTTP(S) externas que desejem acessar os pods.

Repare também como já começo a indicar, em `spec.rules[0].host`,o domínio que estará apontando para o cluster.

### 2.3.4. Service

Escrevemos também o template relacionado ao services.
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-service
  namespace: {{ .Values.namespace }}
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

Descrevendo um service do tipo ClusterIP, o qual tem a função de facilitar a comunicação entre os objetos que estão dentro do cluster.

### 2.3.5. Traefik

O Traefik é mais um service no cluster usado para auxiliar a comunicação. 

```yaml
apiVersion: v1
kind: Service
metadata:
  name: traefik
  namespace: {{ .Values.namespace }}
  labels:
    desafio: jackexperts
spec:
  type: {{ .Values.traefik.service.type }}
  selector:
    app: traefik
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
    - name: https
      port: 443
      targetPort: 443
      protocol: TCP
  {{- if .Values.traefik.service.externalIP }}
  externalIPs:
    - {{ .Values.traefik.service.externalIP }}
  {{- end }}
```

Ele é do tipo LoadBalancer e atrela portas especificas para cada tipo de protocolo. 

Pessoalmente, não entendi muito bem a necessidade de utilizar ele no meu caso, com um só pod, mas essa foi a única solução que consegui encontrar para especificar o endereço de IP que queria atrelar, no caso o IP Público.

Das outras formas, automaticamente o meu endereço de IP privado acabava sendo a ponta do service o que me deixava sem conexão real.

### 2.3.6. Namespace

Por último, o *namespace*:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.namespace }}
  labels:
    desafio: jackexperts
```

Não é uma boa prática criar e rodar os objetos no *namespace default*, por isso criamos arquivo epecificamente para isso e gerenciamos através do `values.yaml`.


## 3.4. `Chart.yaml`:

Nesse aquivo definimos os metadados da aplicação.
```yaml
apiVersion: v2
appVersion: "1.0"
version: 0.1.0
name: desafio-jackexperts
description: Um mapeamento de configurações utilizando Helm para facilitar o deployment da minha solução para o desafio da Jack
type: application
keywords:
  - nginx
  - K3s
  - Kubernetes
  - jackexperts
home: "armandosolheiro.xyz"
sources:
  - "https://hub.docker.com/repository/docker/asolheiro/desafio-jackexperts/general"
  - "https://github.com/asolheiro/desafio-jackexperts"
maintainers:
  - name: Armando A. v. G. Solheiro
    email: avgsolheiro@gmail.com
    url: www.linkedin.com/in/armandosolheiro
```

Nada que altere o funcionamento, apenas informações para descrever o projeto.


## 3.5. `values.yaml`

Chegamos, agora, no, provavelmente, mais importante objeto do Helm.
```yaml
namespace: desafio-jackexperts
replicasCount: 1 
image:
  repository: asolheiro/desafio-jackexperts
  tag: "135414d296559dceb3e0972d7a71abdf1a19ca81"
service:
  type: ClusterIP 
  port: 8080 
traefik:
  service:
    type: LoadBalancer 
    externalIP: "177.93.134.211" 
ingress:
  domain: "armandosolheiro.xyz" 
securityContext:
  runAsUser: 1001 
  runAsGroup: 1001 
  allowPrivilegeEscalation: false
```

É nele que iremos inserir as informações que efetivamente irão configurar o cluster. Definimos domínio, repositório no registry, replicas, IP e até o ID do usuário que criamos no Dockerfile.