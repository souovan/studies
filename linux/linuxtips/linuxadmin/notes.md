# Importante

>```bash
># Por segurança sempre usar esta forma de mudar para usuário root
>/bin/su -
>```

## Dicas

```bash
# Quando finalizando processos relacionados a de bancos de dados utilizar o kill *amigável* para evitar corrupção de dados
kill -15 [PID]
```

```bash
# Ferramenta de gerencimento e manipulação visual modo texto
cfdisk
```

>Caso for provisionar um sistema de arquivos que irá utilizar mais de 16Tb 
>
>Forçe para o tipo ser ext4 que habilita a opção 64bit conforme arquivo de configuração `less /etc/mke2fs.conf`.
> **Esta opção só ser configurada no momento de formatação da partição**

Uso de swap no SSD reduz a vida útil dele

```bash
# Parametro de ajuste do kernel que faz o sistema usar minimamente possivel o swap para preservar o SSD
echo 1 > /proc/sys/vm/sawppiness
```

## Comandos

```bash
# Altera atributos de arquivos e diretórios
chattr

# Lista atributos de arquivos e diretórios
lsattr
```

```bash
ls -lhaF

df -hT
```

## Notas

### BIOS

`BIOS inicialização` é a partição reconhecida pelo boot _legacy_

`Sistema EFI` No boot fica em `/boot/efi/` é uma partição do tipo _vfat_ (Windows) - único tipo de partição reconhecida pela bios *UEFI* - ela carrega sistemas de diagnóstico e kernel ou até o _grub_

### Sistemas de arquivos
 
| `ext3` | `ext4` | `xfs` |
| --- | --- | --- |
| mais antigo com tamanho de partições mais limitado | evolução do _ext3_, permite capacidades maiores e verificação de sistemas de arquivos em caso de corrompimento com uso das `extent` | bastante utilizado em ambiente enterprise, possuí _journaling_ e é mais seguro e menos suscetível a corrupção dos dados |

Quando for realizar migração a quente da partição `/usr` as pastas que podem ser removidas são:

* games/
* include/
* share/
* local/
* src/
* tmp/

***Caso seja removida alguma outra pasta o sistema será inutilizado**

### /etc/fstab

```bash
...
# options 
# noatime = não atualiza access time dos arquivos reduzindo a gravação do sistema de arquivos
# nodiratime = noatime mas para diretórios
# norelatime = não atualiza access time dos inodes importante usar se tiver noatime
# noexec = não permite execução de binários na partição montada
# nodev = não permite montagem de dispositivos na partição montada
/dev/sdaX   /particao    ext4    defaults,noatime,nodiratime,norelatime,noexec   0 0
...
```
### Blocos reservados

5% dos blocos são reservados para manutenção do sistema operacional pelo _root_

```bash
# Quantidade de blocos pode ser conferidas em sistemas ext2, ext3 e ext4 com o comando (Reserved block count)
dumpe2fs <dispositivo> | less
```

```bash
# % de blocos reservados pode ser diminuida com
tune2fs -m 1 <dispositivo>
```

### Discard e trimming

```bash
# Excluir inodes nao utilizados e libera espaço em dispositivos SSD
fstrim -va
```

### LVM (Linux Volume Manager)

> Tecnologia que permite realizar ajuste de particionamento sem precisar parar serviços ou sistema operacional

```
     +---------------+
     | volume fisico | tamanho nao pode ser alterado (particao do HD)
     +---------------+ 
            |
     +------------------+
     | grupo de volumes | uma particao fisica ou mais 
     +------------------+
            |
     +---------------+
     | volume logico | particao real
     +---------------+ 
```

Melhor criar partições pequena e ir aumentando conforme necessidade, pois pode ser necessário desmontar a partição e se for sistema ext4 quando reduzido perde a flag 64bit impedindo que posteriormente a partição seja extendida além do limite de 16Tb

# Troubleshoot de HARDWARE

```bash
# Para avaliar quais dispositivos de hardware estão utilizando os processadores
irqtop
```

# Administração de usuários e grupos

```bash
# Permite manipular permissão de usuários e grupos sem necessidade de root
gpasswd
```

# Redirecionamentos

```bash
> # Redireciona a saida padrao - stdout

< # Redireciona a entrada padrao - stdin

>> # Redireciona a saida padrao e concatena em arquivo/disp indicado

<< # Redireciona a entrada padrao - stdin

2> # Redireciona a saida de erro padrao - stderr

2>> # Redireciona a saida de erro padrao e concatena em arquivo/disp indicado - stderr

2>&1 # Redireciona a saida de erro padrao para um file descriptor nesse caso para o stdout

# FD = File Descriptor
# stdin = 0
# stdout = 1
# stderr = 2
```

> ```bash
> # Exibe sessões dos terminais gráficos
> ps -ef | grep pts
> ```

## Pipe e tee

```bash
# Exibe a saida na saida padrao stdout e também salva a saida dentro do arquivo
ls | tee arquivo.txt
```

> Para que o `tee` adicione o conteúdo ao final do arquivo sem sobrescreve-lo é preciso usar o parametro `-a`

## Localizando ajuda

```
man

info
```

`man` possuí seções para determinados tipos de manuais ver `man man`

> Para buscar qual ajuda verificar no manual
>
> `apropos -e <comando>`

`info` possuí links marcados por `*`, para acessa-los pressione enter

## VIM

```
ESC = retorna ao modo comando

MODO DE INSERÇÃO

i = inserir na posição do cursor
I = inserir no inicio da linha
o = inserir texto na linha abaixo
O = inserir texto na linha acima
a = inserir um caractere a frente
A = inserir no final da linha

SALVANDO E SAINDO
:w = Salvar
:q = Sair
:qa = Sair de todos os arqs abertos
:q! = Sair forçando
:wq = Sair e Salvar
:x = Sair e Salvar
ZZ = Zair e Zalvar - Sair e Salvar
ZQ = Zair sem salvar

COPIANDO COLANDO E RECORTANDO
yy = copia
p = cola na linha abaixo
P = cola na linha acima
y8y = copiar 8 linhas (yNy - copiar N linhas) 
dd = apaga / recorta a linha inteira
d8d = apaga / recorta 8 linhas inteiras
dw = apaga uma palavra
dG = apaga da posiçao atual ate o final do arquivo
dgg = apaga da posiçao atual ate o inicio do arquivo
cw = recortou uma palavra
yw = copiar uma palavra
x = apaga um caractere (igual ao Delete)
X = apaga um caractere antes do cursor (igual ao backspace)
r + N = replace - substituir o caractere atual pelo N

VISUAL
v = visual - selecionar um pedaço do texto
V = visual line - selecionar linhas do texto
CTRL + v = visual block - selecionar um bloco de texto

VOLTANDO E REFAZENDO
u = voltar
CTRL + Z = refazer

BUSCAS e LOCALIZAÇÃO
/STRIGUS = buscar a palavra STRIGUS descendo arquivo
?STRIGUS = buscar a palavra STRIGUS subindo o arquivo
n = continua com a busca
N = continua com a busca ao contrario
gg = vai para a primeira linha
G = vai para a ultima linha
M = meio da tela
H = no alto da tela
L = na parte da tela

COMANDOS set

:set nlsearch = highlight para as buscas
:set number = numera as linhas
:set tabstop = Tamanho do TAB
:set expandtab = converte o TAB em espaços
:set bg=light = muda o esquema de cor
:e BLA = abre outro arquivo BLA
:r BLA = copia o conteudo do arquivo BLA para o arquivo atual
:split BLA = divide a tela com o arquivo BLA
:vsplit BLA = divide a tela com o arquivo BLA
:! comando = executa o comando no shell e retorna para o vim
!! comando = executa e copia/cola o comando para dentro do arquivo


SUBSTITUINDO
:40s/palavra_antiga/palavra_novo/ = substitui na linha 40 a palavara_antiga
:40,50s/palavra_antiga/palavra_novo/ = substitui entre a linha 40 e a linha 50 a palavara_antiga
:%s/palavra_antiga/palavra_novo/ = substitui a palavara_antiga em todo o arquivo - uma palavra por linha
:%s/palavra_antiga/palavra_novo/g = substitui a palavara_antiga em todo o arquivo
```

