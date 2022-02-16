<pre>
   _____              _____    _____   _  __
  / ____|     /\     |  __ \  |_   _| | |/ /
 | (___      /  \    | |__) |   | |   | ' / 
  \___ \    / /\ \   |  _  /    | |   |  <  
  ____) |  / ____ \  | | \ \   _| |_  | . \ 
 |_____/  /_/    \_\ |_|  \_\ |_____| |_|\_\
                                            
</pre>
# [Segurança Automática de Regras em Iptables no Kubernetes](http://sarik.org)

### [Website](https://sarik.org/)  &nbsp; [Manual](http://sarik.org/manual) &nbsp;  [Vídeos](http://sarik.org/videos) &nbsp;

[![APM](https://img.shields.io/apm/v/vim-mode?color=blue&label=SARIK&logo=SARIK&logoColor=blue)](https://sarik.org/) &nbsp; 
<p align="justify">
SARIK é um framework back-end que realiza mapeamento do estado que o cluster se encontra. Através dessa análise, consegui configurar automaticamente regras de iptables nos diversos PODs pertencentes ao node (cluster). O framework é uma camada de proteção que traz aos PODs maior segurança na orquestração de containers kubernetes.

A versão 1.0 do SARIK realiza diversas expressões regulares e por meio dessas ações, o framework consegui verificar o estado do cluster e armazenar os valores necessários para configuração de todos os PODs de um node.
</p>

## Instalação &nbsp;
Após o download do pacote do software, extraia o conteúdo e acesse a pasta
```sh
# Caso não tenha um app em funcionamento, execute essas próximas etapas para testar o SARIK.
# Caso contrário, vá para execução do script.

# Acesse a pasta AppTest/debian e execute os comandos nessa ordem

$ kubectl create -f namespaces/
```
```sh
$ kubectl create -f services/
```
```sh
$ kubectl create -f deployements/
```

Aguarde os PODs serem carregados, dependendo da conexão, esse processo demora de 2 até 5 minutos

```sh
# Retorne a pasta raiz

$ cd ../..
```

## Execução do script
```sh
# Execute o script do SARIK

$ bash sarik.sh
```

## Links &nbsp;

- [Website](https://sarik.org)
- [Download](https://sarik.org/download)
- [Manual](https://sarik.org/manual)
- [Vídeos](https://sarik.org/videos)

## Autor &nbsp;

Jonathan G.P. dos Santos

## Agradecimentos &nbsp;

Dr. Vinícius Pereira Gonçalves  - Orientador do projeto

Dr. Geraldo Pereira Rocha Filho - Coorientador do projeto

Tainá Narô da Silva de Moura

Luiz Eduardo Rodrigues Lima

## Equipe &nbsp;

[![Jonathan G. P. Santos](https://sarik.org/images/jonathan.jpg)](https://orcid.org/0000-0003-1830-0055) |  [![Vinícius P. Gonçalves](https://sarik.org/images/vinicius.jpg)](https://orcid.org/0000-0002-3771-2605) |  [![Geraldo P. R. Filho](https://sarik.org/images/geraldo.jpg)](https://orcid.org/0000-0001-6795-2768) | [![Tainá N. S. Moura](https://sarik.org/images/taina.jpg)](#) | [![Luiz Eduardo Rodrigues Lima](https://sarik.org/images/luiz.jpg)](https://br.linkedin.com/in/luizerl?trk=people-guest_people_search-card)
|:---:|:---:|:---:|:---:|:---:|
[Jonathan G. P. Santos](http://github.com/jonathamgg) | [Vinícius P. Gonçalves](https://orcid.org/0000-0002-3771-2605) | [Geraldo P. R. Filho](https://orcid.org/0000-0001-6795-2768) | [Tainá N. S. Moura](http://lattes.cnpq.br/6867008647987431) | [Luiz E. R. Lima](https://br.linkedin.com/in/luizerl?trk=people-guest_people_search-card) |
