<pre>
   _____              _____    _____   _  __
  / ____|     /\     |  __ \  |_   _| | |/ /
 | (___      /  \    | |__) |   | |   | ' / 
  \___ \    / /\ \   |  _  /    | |   |  <  
  ____) |  / ____ \  | | \ \   _| |_  | . \ 
 |_____/  /_/    \_\ |_|  \_\ |_____| |_|\_\
                                            
</pre>
# [Segurança Automática de Regras em Iptables no Kubernetes](http://sarik.org)

### [Website](https://sarik.org/)  &nbsp; [GUIA](#) &nbsp;  [Doc](http://sarik.org/documentation)  &nbsp; [VÍDEOS](#) &nbsp;

![APM](https://img.shields.io/apm/v/vim-mode?color=blue&label=SARIK&logo=SARIK&logoColor=blue) 
<p align="justify">
SARIK é um framework back-end que realiza mapeamento do estado que o cluster se encontra. Através dessa análise, consegui configurar automaticamente regras de iptables nos diversos PODs pertencentes ao node (cluster). O framework é uma camada de proteção que busca trazer aos PODs maior segurança no orquestrador de container kubernetes.

A versão 1.0 do SARIK realiza diversas expressões regulares e por meio dessas ações, o framework consegui verificar o estado do cluster e armazenar os valores necessários para configuração de todos os PODs de um node.
</p>

## Instalação &nbsp;
Após o download do pacote do software, extraia o conteúdo e acesse a pasta
```sh
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

$ ../..
```

```sh
# Execute o script do SARIK

$ bash sarik.sh
```


SITE:          https://sarik.org

Autor:         Jonathan G.P. dos Santos

Agradecimentos:

Dr. Vinícius Pereira Gonçalves  - Orientador do projeto

Dr. Geraldo Pereira Rocha Filho - Co-Orientador do projeto

Luis Eduardo Rodrigues Lima
[![Jonathan Santos](https://avatars.githubusercontent.com/u/8846965?s=96&v=4)] |  [![Rachael McNeil](https://avatars0.githubusercontent.com/u/3065949?v=3&s=144)](http://twitter.com/fancydoilies) |  [![Eric Shaw](https://avatars2.githubusercontent.com/u/7445991?s=144&v=3)](https://github.com/eashaw)
|:---:|:---:|:---:|
[Jonathan Santos](http://github.com/jonathamgg) | [Rachael McNeil](https://github.com/rachaelshaw) | [Eric Shaw](https://github.com/eashaw)
