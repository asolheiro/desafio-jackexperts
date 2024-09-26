
# Desafio-jackexperts

## 1. Introdução

Este documento descreve a estrutura, configuração e processo de instalação do projeto **desafio-jackexperts**. 
Esse desafio foi proposto pela [Jack Experts](https://github.com/JackExperts). 

O projeto consiste em:
> **Aplicação simples com página HTML customizável, definida via Helm e hospedada em um cluster Kubernetes**

Essa documentação diz respeito ao meu processo no Linux - Ubuntu. Verifique a distribuição do seu sistema operacional antes de prosseguir.

## 2. Ferramentas utilizadas
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


## 3. Arquitetura

# Arquitetura da Solução

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

## Instalação:
Todos os processos de instalação mostrados aqui foram retirados das suas respectivas documentações oficiais. Há

### Instalação Local Kubernetes ([Kind](https://kind.sigs.k8s.io/)):
1. Instalar o Kind localmente:

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
3. **Criar um cluster Kind com um control-plane e dois workers, definido pelo kind.yaml:**
```bash
kind create cluster --config kind.yaml  
```

4.  **Configurar o kubectl:** 
```
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

### Instalação na Amazon Web Service:

1.  **Criar um cluster Kubernetes na AWS:** 
[**Comandos ou instruções para criar o cluster na AWS**]
2.  **Instalar e configurar o kubectl:** 
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
Teste a instalação verificando a versão do kubectl:
```bash
kubectl version --client --output=yaml
```
[**Comandos para configurar o kubectl para se conectar ao cluster da AWS**]
3.  **Instalar o Helm:** 
[**Comando para instalar o Helm**]
4.  **Instalar o projeto:**
```bash
helm install <RELEASE-NAME> ./
```
Substitua `<RELEASE-NAME>` pelo nome desejado para o release.

#### Configuração do Domínio

1.  **Criar um LoadBalancer:**

```bash
kubectl expose deployment <DEPLOYMENT-NAME> --type=LoadBalancer
```
    
Substitua `<DEPLOYMENT-NAME>` pelo nome do seu deployment.

2.  **Obter o endereço IP do LoadBalancer:**
```bash
kubectl get services
```
    
3.  **Configurar o DNS:** Adicione um registro A no seu DNS apontando o domínio rmndvngrpslhr.com para o endereço IP do LoadBalancer.
## Pipeline:

## Detalhes Adicionais:

-   **Estrutura de diretórios:**
    -   **templates:** Contém os templates Helm para criar os recursos Kubernetes.
    -   **charts:** Contém gráficos e outros arquivos de configuração.
    -   **values.yaml:** Arquivo de valores para personalizar a instalação.
-   **ConfigMap:** O ConfigMap contém a configuração do Nginx, incluindo as configurações de proxy reverso.
-   **Serviço:** O serviço expõe a aplicação para o mundo externo através de um LoadBalancer.
 
### Próximos Passos
- **Pipeline**
- **Resources para o deployment**
- **Documentação das variáveis helm**
-   **Monitoramento:** Implementar ferramentas de monitoramento para acompanhar a saúde e o desempenho da aplicação.
-   **Log:** Configurar o log para coletar e analisar as informações de log da aplicação.
-   **Segurança:** Implementar medidas de segurança para proteger a aplicação e os dados.

**Possíveis tópicos para serem adicionados:**

-   **Configuração do Nginx em detalhes**
-   **Estrutura da página web**
-   **Processo de build da imagem Docker**
-   **Testes unitários e de integração**
-   **Melhores práticas de desenvolvimento**
-   **Gerenciamento de configurações**
