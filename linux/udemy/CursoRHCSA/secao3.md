# Comandos utilizados no exame RHCSA

```bash
# Descreve os diretórios do sistema de arquivo Linux ( FSH )
man 7 hier
```
## Comandos básicos de navegação

```bash
pwd # print working directory

cd # change directory
```

> entradas especiais
> .  - diretório atual
> .. - diretório pai

> caminho absoluto sempre começa com /

> caminho relativo é relativo ao diretório mostrado com `pwd` e existe apenas o caminho do diretório atual até o arquivo necessário

## Login mode

```bash
# usa o arquivo ~/.bash_profile  
su - user1
```
## Non Login mode

```bash
# usa o arquivo ~/.bashrc
su user1
```

```bash
# mostra o caminho absoluto do comando
which <comando>
```

## Criar e remover diretórios

```bash
# cria um diretório
mkdir exemplo

# cria um diretório com um caminho que não exista com a bandeira -p ( path )
mkdir -p exemplo/exemplo2
```

```bash
# remove um diretório vazio
rm exemplo
```

```bash
# remove diretório que contém arquivos e pede confirmação
rm -ri exemplo
```

# Gerenciamento de arquivos de texto

```bash
# leitor de arquivos de texto
less
# barra - passa uma página 
# page up - sobe uma pagina
# seta para baixo - pula linha por linha
# ^G - vai para o final do arquivo
# ^GG - vai pro inicio do arquivo
# / - pesquisa 
#   n(next) - vai para a próxima ocorrência
#   p(previous) - volta para a ocorrência anterior
# v - passa pro editor de texto configurado na variável de ambiente $SHELL
```

```bash
# exibe as 10 primeiras linhas por padrão
head
```

```bash
# exibe as 10 últimas linhas por padrão
tail 
```

```bash
# remove partes das linhas dos arquivos e apresenta saída no terminal
cut
```


