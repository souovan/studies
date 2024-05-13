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

# Saídas padrão SHELL

| Nome | Destino padrão | Redirecionamento | Número que descreve arquivo |
| --- | --- | --- | --- |
| STDIN | Teclado | <(mesmo que 0<) | 0 |
| STDOUT | Monitor | >(mesmo que 1>) | 1 |
| STDERR | Monitor | 2> | 2 |

# Redirecionamentos comuns do bash

| Redirecionamento | Descrição |
| --- | --- |
| > (mesmo que 1>) | Redireciona o STDOUT. Se para um arquivo, o conteúdo do arquivo é apagado |
| < (mesmo que 0<) | Redireciona o STDIN |
| >> (mesmo que 1>>) | Redireciona o STDOUT. Se para um arquivo, adiciona ao final do arquivo |
| 2> | Redireciona o STDERR | 
| 2>&1 | Redireciona STDERR para o mesmo destino que STDOUT |

# PIPES

>[!TIP]
> Representado pela barra vertical: |
> Transfere a saída do comando a esquerda para o comando a direita
> Podem ser feitos diversos pipes: 
> `comando1 | comando2 | comando3`

# Principais comandos do VI

| comando | descrição |
| --- | --- |
| ESC |  |
| i | entrar no modo inserir |
| o | abre uma linha embaixo da linha atual no modo comando |
| :wq | write and quit (escreve(salva) e termina o programa) |
| :q! | sai do programa sem salvar |
| :w nome | salva arquivo atual para outro arquivo chamado "nome" |
| dd | apaga linha atual em modo comando |
| yy | cola seleção atual em modo comando |
| v | modo visual (usado para selecionar partes do texto) |
| u | undo(desfaz última modificação) em modo comando |
| gg | vai para o inicio do texto em modo comando |
| G | vai para o final do texto em modo comando |
| / | busca para baixo do texto em modo comando |
| ? | busca de baixo para cima em modo comando |

# Link físico e simbólico

>[!NOTE]
> * Links são como atalhos para um outro arquivo
> * Cada nome de arquivo sabe qual o inode que tem que acessar para obter informação sobre o arquivo
> * Cada nome associado com um inode se chama um "Link Físico":
>   - Link físicos precisam estar no mesmo dispositivo (exemplo: /dev/sdb)
>   - Não pode usar para diretórios
>   - Quando o último link físico for removido, blocos associados são removidos também.

```bash
# Cria um link físico chamado "nome_do_link" para o arquivo chamado "destino"
$ ln destino nome_do_link

# Cria um link simbólico chamado "link" para o arquivo "/etc/hosts"
# ln -s /etc/hosts link
```

>[!CAUTION]
> NÃO UTILIZAR -r ou -f: `rm -rf` QUANDO APAGANDO LINK, POIS TAMBÉM APAGARÁ O CONTEÚDO DO DIRETÓRIO OU ARQUIVO ALVO DO LINK
>
> Se o arquivo alvo do link físico for excluído o link físico continua funcionando pois ele aponta para o bloco de dados

```bash
$ ls -l meuarquivo
#  user
#   | group
#   | |  other usuario dono do arquivo
#   | |  |      |
# -rw-rw-r--. 1 user user 0 Out 16 03:39 meuarquivo
# |                   |
# tipo de arquivo    grupo dono do arquivo
```

```bash
# Muda permissão de arquivos e diretórios
chmod
```

```bash
# Edita grupos e usuarios donos do arquivo ou diretório
chown
```

# Uso das permissões ler, escrever e executar

As permissões seguem o padrão `ugo`
```
# user (rwx) group(r-x) other(r-x)
-rwxr-xr-x 1 root root 1799 fev 16 17:09 file.txt
```

Permissão especial `s`

user + s

Conhecida como **SUID** tem a função de o arquivo com **SUID** sempre executar como o dono do arquivo

group + s

Conhecida como **SGID** tem duas funções:
* Se usada em um **arquivo** permite o arquivo ser executado como o grupo dono do arquivo
* Se usada em um **diretório** qualquer arquivo criado no diretório vai receber o grupo do dono do diretório

Other + t

**Stick bit** não afeta arquivos individuais e sim **diretórios e restrige sua exclusão**


| Permissão | Para arquivos | Para diretórios |
| --- | --- | --- |
| Ler | Abrir um arquivo | Listar conteúdo |
| Escrever | Mudar conteúdo do arquivo | Criar, deletar, e mudar permissões do arquivo |
| Executar | Rodar um arquivo(script;programa) | Mudar para o diretório |

# Permissões para o CHMOD

| Permissão | Numérico | Permissão |
| --- | --- | --- |
| Ler | 4 | r |
| Escrever | 2 | w |
| Executar | 1 | x |

# Funcionamento do umask

O umask é um bitmask octal que limpa as permissões de novos arquivos e diretórios que um processo cria. Se um bit for definido no umask, a permissão correspondente será desmarcada nos novos arquivos. 

Exemplo de cálculo de umask de um arquivo

| | Symbolic | Numeric octal | Numeric Binary |
--- | --- | --- | ---
Initial file permissions | rw-rw-rw- | 0666 | 000 110 110 110
umask | -------w- | 0002 | 000 000  000 010
Resulting file permissions | rw-rw-r-- | 0664 | 000 110  110 100

# Buscando ajuda no Linux

> <comando> --help ou -h

> man <comando>

## Dica
```bash
# Atualiza as páginas do man
mandb 
```

```
# pesquisar tópicos e filtrar com grep pra localizar arquivos de configuração
man -k <tópico> | grep <filtro>
```

> info
> ou
> info <comando>

>/usr/share/doc

# Painel de controle do RHEL (futuro substituto do virt-manager)
```bash
# Instala o painel de controle
dnf install -y cockpit

# Habilita o painel de controle e inicia
systemctl enable cockpit.socket
systemctl start cockpit.socket

# Habilita a porta do painel de controle no firewall
firewall-cmd --permanent --add-port=9090/tcp
```
> O painel de controle possui uma interface web que poderá ser aberta em https://localhost:9090
> E para login deverão ser utilizados os usuários disponíveis na máquina host(servidor)

