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

## 2.1. Resumo

De forma resumida o Helm é um gerenciador de pacotes para o Kubernetes que facilita a instalação e o manuseio das aplicações. 

Para funcionar, ele utiliza os ***"charts***", pacotes pré-configurados com os recursos necessários para rodar uma aplicação, tais como deployments, serviços e configurações. 

Com o Helm, a gente pode instalar, atualizar e gerenciar as aplicações no Kubernetes de maneira fácil e rápida, além de permitir que as configuralções possam ser reutilizadas e compartilhadas entre os ambiente e *releases*.

## 2.2 Primeiros passos

```bash
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
