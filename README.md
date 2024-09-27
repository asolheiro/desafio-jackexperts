
# Desafio-jackexperts

## 1. Introdução

Este documento descreve a estrutura, configuração e processo de instalação do projeto **desafio-jackexperts**. 
Esse desafio foi proposto pela [Jack Experts](https://github.com/JackExperts). 

O projeto consiste em:
> **Aplicação simples com página HTML customizável, definida via Helm e hospedada em um cluster Kubernetes**

Essa documentação diz respeito ao meu processo no Linux - Ubuntu. Verifique a distribuição do seu sistema operacional antes de prosseguir.

### 1.2. Ferramentas utilizadas
Para teste local:
- **Kind:** Kubernetes IN Docker, para testes locais.
- **Kubectl:** Ferramenta CLI para interagir com clusters Kubernetes.
- **Helm:** Gerenciador de pacotes para kubernetes.

Para *deploy* na nuvem:
- **K3s:** Cluster kubernetes *single-node*.
- **Helm:** Ferramenta de gerenciamento de pacotes para Kubernetes.
- **Kubectl:** Ferramenta de linha de comando para interagir com o Kubernetes.
- **Magalu Cloud:** VM instanciada na Magalu Cloud para *deploy*.
- **Um domínio:** O [armandosolheiro.xyz](http://armandosolheiro.xyz) que apontará para o cluster.


## 2. Arquitetura da solução

- **Repositório Git**
  - Contém o código-fonte da aplicação e o Dockerfile
  - Inclui os templates do Helm para o gerenciamento da aplicação

- **Docker**
  - Imagem da aplicação construída com um Dockerfile personalizado
  - A imagem é publicada no Docker Hub
  - A aplicação não roda como usuário root

- **Kubernetes**
  - Deploy realizado em uma VM com k3s no MagaluCloud
  - Utilização do Helm para definir e gerenciar todos os objetos da aplicação:
    - ConfigMap para tornar a página web configurável
    - Deployment para gerenciar os pods da aplicação
    - Service para expor a aplicação dentro do cluster
    - Ingress para gerenciar o tráfego externo e roteamento
  - Todos os objetos do cluster possuem a label `desafio=jackexperts`

- **Domínio**
  - Utilização do Hostinger para o registro e configuração do domínio da aplicação

- **Documentação**
  - Documentação abrangente sobre a arquitetura, configuração e uso da aplicação

## 3. Nginx


## 4. Helm
Helm é um gerenciador de pacotes utilizado para facilitar e padronizar o deploy de aplicações. Com ele, definimos templates de arquivos manifestos para um para cada um dos objetos do Kubernetes e um arquivo `values.yaml` que guarda as variáveis que desejamos aplicação:

A estrutura utilizado é a seguinte:
```perl
desafio-jackexperts/
├── Chart.yaml          # Metadados do projeto
├── values.yaml         # Valores de configuração padrão
├── charts/             # Dependências do projeto
├── templates/          # Modelos de recursos Kubernetes
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── ingress.yaml
│   ├── index.html.tpl
│   ├── namespace.yaml
│   ├── service.yaml  
│   ├── traefik-service.yaml   
│   └── _helpers.tpl     
└── .helmignore
```
Abaixo, o detalhamento dos arquivos de configuração

### 4.1. Mapeamento de variáveis

A tabela a seguir lista os parâmetros configurados para o mapeamento "desafio-jackexperts" assim como suas descrições e valores definidos em `values.yaml`.

| Parâmetro                | Descrição               | Valor        |
| ------------------------ | ----------------------- | -------------- |
| `namespace` | namespace da aplicação | `"desafio-nginx"` |
| `replicasCount` | número de replicas | `1` |
| `image.repository` | repositório do registry que armazena a imagem | `"asolheiro/desafio-jackexperts"` |
| `image.tag` | tag da imagem | `"bb1717130714b223540d47f0a564b4df12312a3b"` |
| `service.type` | tipo do service criado | `"ClusterIP"` |
| `service.port` | porta do service criado | `8080` |
| `traefik.service.type` | tipo do service | `"LoadBalancer"` |
| `traefik.service.externalIP` | IP da VM que hospeda o Cluster | `"177.93.134.211"` |
| `ingress.domain` | domínio que aponta para o cluster | `"armandosolheiro.xyz"` |
| `securityContext.runAsUser` | informações sobre o usuário criado no Dockerfile | `1001` |
| `securityContext.runAsGroup` | informações sobre o usuário criado no Dockerfile | `1001` |
| `securityContext.allowPrivilegeEscalation` | impede privilégios adicionais no contêiner | `false` |

### 4.2. Templates adicionais

Para conseguir importar com sucesso o `index.html` usando o `configmap.yaml` foi necessário criar um novo template chamado `desafio-jackexperts.index.html.tpl` em `/templates/index.html.tpl`:
```html
{{- define "desafio-jackexperts.index.html.tpl" -}}
<!-- Conteúdo do index.html -->
{{- end -}}
```

Dessa forma, em `/templates/configmap.yaml` podemos importar o template usando:

```yaml
data:
  index.html: |
    {{ include "desafio-jackexperts.index.html.tpl" . | indent 4 }}
```

## 5. Instalação:
Todos os processos de instalação mostrados aqui foram retirados das suas respectivas documentações oficiais.

### 5.1. Instalação Local Kubernetes ([Kind](https://kind.sigs.k8s.io/)):
1. **Instalar o Kind localmente**:

```bash
# Para AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
# Para ARM64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
	
2. **Instalar o [kubectl](https://kubernetes.io/docs/reference/kubectl/):** 

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Teste a instalação verificando a versão do kubectl:

```bash
kubectl version --client --output=yaml
```

3. **Criar um cluster Kind com um Control-plane e dois Workers, definido pelo kind.yaml:**
```bash
kind create cluster --config kind.yaml  
```
Onde o arquivo `kind.yaml` está definido como:
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker

```

4.  **Configurar o kubectl:** 

```bash
kubectl config use-context kind-kind
```
    
5.  **Instalar o Helm:**

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

Verifique a instalação com:
```bash
helm version
```

6.  **Testar o helm chart:**

```bash
helm template <RELEASE-NAME> --debug
```
Se os arquivos de configuração forem gerados corretamente, então prossiga para a instalação

7.  **Instalar o projeto:**

```bash
helm install <RELEASE-NAME> ./
```
Substitua `RELEASE-NAME` pelo nome desejado para o release.


8. **Executar o projeto:**

Obtenha o endereço de IP executando o comando abaixo e coletando o `EXTERNAL-IP`

```bash
kubectl get ingress
```

> Nota: é possível que hajam inconsistências na execução se o Ingress estiver configurado para funcionar com hosts externos. Verifique com atenção os arquivos de configuração para seu caso de uso específico.

### 5.2. Instalação na MagaluCloud:

1.  **Instanciar uma VM na cloud:** 

Utilizamos o k3S como distribuição Kubernetes. Segundo a [documentação da ferramenta](https://docs.k3s.io/installation/requirements?os=debian#hardware), os requisitos são o seguinte:


| Recurso | Mínimo | Recomendado |
|:-------:|:------:|:-----------:|
| CPU     | 1 core | 2 core      |
| RAM     | 512 MB | 1 GB        |

```bash
mgc virtual-machines instances create \
    --name=<VM_NAME> \
    --machine-type.name="cloud-bs1.xsmall" \
    --image.name="cloud-ubuntu-24.04 LTS" \
    --ssh-key-name=<SSH_KEY>
```
Na documentação da cloud está especificado que a menor máquina que atende os recursos recomendadis é a *"cloud-bs1.xsmall"*, por isso optamos por ela.


2.  **Acessar a VM:**

Acessamos sempre via SH durante esse projeto.
```bash
ssh <VM_USER>@<VM_IP>
```
Autentique, se preciso.

3.  **Instalar e configurar o kubectl:** 

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
Teste a instalação verificando a versão do kubectl:
```bash
kubectl version --client --output=yaml
```

4. **Instalar o k3s na VM:**

```bash
curl -sfL https://get.k3s.io | sh -
```

Utilizaremos um cluster *single-node*, pois este é um projeto pessoal de baixa complexidade. Para projetos em produção seria necessário adicionar mais *nodes*. 

A documentação indica que, para adicionar mais nós Cluster é necessário executar na máquina que se deseja adicionar:
```bash
curl -sfL https://get.k3s.io | K3S_URL=https://<SERVER_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -
```
`K3S_TOKEN` está disponível em `/var/lib/rancher/k3s/server/node-token`

5.  **Configurar o kubectl:**

Para que o Kubectl local possa agir corretamente no Cluster da VM, é necessário que tenhamos o `config.yaml` deste cluster. No caso do k3s, essa informação fica armazenada em `etc/rancher/k3s/k3s.yaml`.

Traga para a máquina local o arquivo e utilize-o para exportar como variável de ambiente o arquivo de configurações:
```bash
scp  -r etc/rancher/k3s/k3s.yaml@<VM_IP>:~/.kube/config
export KUBECONFIG=~/.kube/config
```

6.  **Instalar o Helm:** 

Na sua máquina local:
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

7.  **Testar o projeto**

```bash
helm template <RELEASE-NAME> ./helm --debug
```

Substitua `<RELEASE-NAME>` pelo nome desejado para o release.
Verifique se os arquivos de configuração gerados estão corretos, então prossiga com a instalação

8.  **Instalar o projeto:**

```bash
helm install <RELEASE-NAME> ./helm
```
Substitua `<RELEASE-NAME>` pelo nome desejado para o release.

## 6. Configuração do Domínio

1.  **Obter o endereço IP do LoadBalancer:**

```bash
kubectl get services -A
```
    
2.  **Configurar o DNS:** 

Na interface da plataforma fornecedora do domínio, 
- adicione um **registro A** no seu DNS 
- selecione o domínio desejado, nesse caso armandosolheiro.xyz 
- aponte-o para o endereço IP do LoadBalancer.

## 7. Pipeline:

Esta SEÇÃO descreve a pipeline do GitHub Actions utilizada para construir, testar, publicar e implantar uma aplicação Dockerizada no Kubernetes. 

A pipeline é composta por cinco jobs principais: 
- `build`, 
- `test`, 
- `push`, 
- `update`
- `deploy`.

### 7.1 Estrutura da Pipeline

A pipeline é acionada em cada push para a *branch* `main`. A seguir, cada job é descrito em detalhes.

#### 7.1.1. Build Docker Image

**Job: `build`**

- **Descrição**: Este job é responsável por construir a imagem Docker da aplicação.
- **Ambiente**: `ubuntu-latest`
- **Serviços**: Utiliza o Docker-in-Docker (dind) na versão `27.3.1`.

##### Passos:
1. **[Checkout repository](https://github.com/actions/checkout)**: Clona o repositório do GitHub.
2. **[Set up Docker buildx](https://github.com/docker/setup-buildx-action)**: Configura o Docker Buildx para construção de imagens.
3. **[Build and export](https://github.com/docker/build-push-action)**: Constrói a imagem Docker e a exporta para um arquivo tar.
4. **[Upload artifact](https://github.com/actions/upload-artifact)**: Faz o upload do arquivo tar gerado como artefato.


### 7.2. Run Trivy Security Scan

**Job: `test`**

- **Descrição**: Executa uma varredura de segurança usando o Trivy para identificar vulnerabilidades na imagem Docker.
- **Ambiente**: `ubuntu-latest`
- **Dependências**: Necessita do job `build`.

#### 7.2.1. Passos:
1. **[Checkout repository](https://github.com/actions/checkout)**: Clona o repositório novamente.
2. **[Download artifact](https://github.com/actions/download-artifact)**: Faz o download do arquivo tar com a imagem Docker.
3. **[Load Docker image](https://docs.docker.com/reference/cli/docker/image/load/)**: Carrega a imagem Docker do arquivo tar.
4. **[Run trivy vulnerability scanner](https://github.com/aquasecurity/trivy-action)**: Realiza a varredura de vulnerabilidades na imagem.
5. **[Publish Trivy Output to Summary](https://github.com/aquasecurity/trivy)**: Publica os resultados da varredura no resumo do GitHub.
6. **[Upload artifact](https://github.com/actions/upload-artifact)**: Faz o upload dos resultados da varredura como artefato.
7. **[Run trivy in GitHub SBOM mode and submit results to Dependency Graph](https://github.com/aquasecurity/trivy-action)**: Envia resultados ao gráfico de dependências do GitHub.

### 7.3. Push Docker Image

**Job: `push`**

- **Descrição**: Este job é responsável por enviar a imagem Docker para o Docker Hub.
- **Ambiente**: `ubuntu-latest`
- **Dependências**: Necessita do job `test`.

#### 7.3.1. Passos:
1. **[Checkout repository](https://github.com/actions/checkout)**: Clona o repositório novamente.
2. **[Download artifact](https://github.com/actions/download-artifact)**: Faz o download do arquivo tar com a imagem Docker.
3. **[Load Docker Image](https://docs.docker.com/reference/cli/docker/image/load/)**: Carrega a imagem Docker do arquivo tar.
4. **[Login to DockerHub](https://github.com/docker/login-action)**: Realiza o login no Docker Hub usando credenciais armazenadas como segredos.
5. **[Push to DockerHub](https://docs.docker.com/reference/cli/docker/image/push/)**: Envia a imagem Docker para o Docker Hub.

### 7.4. Update Helm Chart

**Job: `update`**

- **Descrição**: Atualiza o Helm Chart da aplicação com a nova tag da imagem.
- **Ambiente**: `ubuntu-latest`
- **Dependências**: Necessita do job `push`.

#### 7.4.1 Passos:
1. **[Checkout repository](https://github.com/actions/checkout)**: Clona o repositório novamente.
2. **[Clone Helm repository](https://git-scm.com/docs/git-clone)**: Clona o repositório Helm onde os valores serão atualizados.
3. **[Update Helm values](https://github.com/mikefarah/yq)**: Modifica o arquivo `values.yaml` para incluir a nova tag da imagem.
4. **[Commit and push](https://git-scm.com/docs/git-push/pt_BR)**: Realiza o commit das alterações e envia para o repositório.

### 7.5. Deploy to Kubernetes

**Job: `deploy`**

- **Descrição**: Implanta a aplicação no cluster Kubernetes usando Helm.
- **Ambiente**: `ubuntu-latest`
- **Dependências**: Necessita do job `update`.

#### 7.5.1. Passos:
1. **[Checkout repository](https://github.com/actions/checkout)**: Clona o repositório novamente.
2. **[Install Helm](https://helm.sh/docs/intro/install/)**: Baixa e instala o Helm.
3. **[Set up Kubeconfig](https://kubernetes.io/pt-br/docs/concepts/configuration/organize-cluster-access-kubeconfig/)**: Decodifica e configura o Kubeconfig usando um segredo.
4. **[Verify kubectl access](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_get/)**: Realiza uma verificação para garantir que o `kubectl` pode acessar o cluster.
5. **[Helm upgrade](https://helm.sh/docs/helm/helm_upgrade/)**: Clona o repositório Helm e realiza o upgrade ou instalação do chart.

## 8. Considerações Finais

Esta pipeline automatiza o processo de construção, teste e implantação de uma aplicação Dockerizada, garantindo que as imagens sejam seguras e estejam sempre atualizadas no cluster Kubernetes. O uso de ferramentas como Trivy para análise de vulnerabilidades e Helm para gerenciamento de pacotes Kubernetes oferece uma abordagem robusta e segura para DevOps.

## 9. Próximos Passos:

Aqui temos alguns pontos que podemos adicionar no futuro para deixar o projeto mais completo.

- **Resources para o deployment:** *limits* e *requests* para os pods
- **Documentação das variáveis helm**
- **Monitoramento:** Implementar ferramentas de monitoramento para acompanhar a saúde e o desempenho da aplicação.
- **Log:** Configurar o log para coletar e analisar as informações de log da aplicação.
- **Segurança:** Implementar medidas de segurança para proteger a aplicação e os dados.

**Possíveis tópicos para serem adicionados:**
-   **Configuração do Nginx em detalhes**
-   **Melhores práticas de desenvolvimento**
-   **Gerenciamento de configurações**
