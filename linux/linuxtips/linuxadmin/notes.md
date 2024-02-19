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

## Variáveis de ambiente

```bash
# Exibe as variáveis de ambiente 
env 
# Exibe as variáveis de ambiente
printenv 
# Exibe o valor da variável 
printenv <VARIAVEL> 
# Seta valor para variável de ambiente local
set VARIAVEL=valor
# Seta valor para a variável de ambiente global
export VARIAVEL=valor
# Remove valor das variáveis
unset VARIAVEL
# Atribui dois valores para uma variável de ambiente
export VARIAVEL=valor1:valor2
```

> Para que a variável de ambiente persista a reboot é preciso adiciona-la a um dotfile (.bashrc, .profile etc)
>
> Porém o local correto onde a variável deve ser adicionada é em `/etc/environment`

> Quando for alterar as variáveis LANG também deve ser informado o encoding:
> ```bash
> LANG=pt_BR.UTF-8
> LC_MESSAGES=pt_BR.UTF-8
> LC_ALL=pt_BR.UTF-8
>
> #Para verificar as opções de encoding disponíveis
> cat /etc/locale.gen
> ```

### Alias

```bash
# Cria um atalho
alias comando="comando"

# Remove um atalho
unalias comando
```

> Para que o atalho fique disponivel após reboot é preciso adiciona-lo a um dotfile (.bashrc, .profile etc)

## Gerenciamento de Logs

```bash
# Arquivo de configuração dos logs
vim /etc/rsyslog.conf
```

> Mantenha os logs em um servidor dedicado para evitar perda em caso de crash da máquina ou apagamento

```bash
# Comando para visualização dos logs sem olhar diretamente nos arquivos de logs
man journalctl 
```

### Redes

```bash
# Arquivo de configurações de rede
/etc/network/interfaces
```

```bash
# Comando para listar rotas
ip route ls
```

```bash
# Ferramenta para cálculo de subrede (apt-get install -y subnetcalc)
subnetcalc <IP/CIDR>
```

> Opção `auto <interface>` no arquivo `/etc/network/interfaces` sobe a placa de rede/configuração de forma forçada no boot
> 
> Opção `allow-hotplug <interface>` no arquivo `/etc/network/interfaces` só sobe a configuração de rede se houver um link conectado e funcional na máquina (utilizado para redundância)

> É possível configurar execução de comandos/scripts através do arquivo `/etc/network/interfaces` ( por exemplo quando houver queda/reconexão )

#### Portas

```bash
# Arquivo que mapeia portas mais comuns de acordo com o serviço padrão
less /etc/services
```

### Segurança

```bash
# Exibe usuários que estão conectados ao terminal
less /etc/securetty
```

```bash
# Comando que exibe quem está conectado e o que o usuário está fazendo
w
```

> Boa prática não deixar terminais conectados e proibir acesso do usuário root ao console tty1 e proibir acesso com usuário root através de senha (utilizar certificado ou kerberos)

#### Algumas dicas de Hardening

```bash
# É possível restrigir acesso via usuário root a terminais virtuais comentando a linha ao determinado terminal no arquivo
/etc/securetty
```

```bash
# É possível restrigir quais usuários podem conectar via ssh através do arquivo
/etc/ssh/sshd_config

# Importante testar se a configuração do arquivo está correta com o comando
sshd -t
```

##### TCP Wrappers

```bash
# É possível restrigir acesso a partir de determinados hosts editando os arquivos
/etc/hosts.allow
/etc/hosts.deny
```

> Ordem de checagem de acessos Firewall, TCP Wrappers, arquivo `/etc/ssh/sshd_config`

#### Comandos para troubleshoot de rede

```bash
# Exibe quem está logado
who
```

##### Serviços inseguros

```bash
telnet
```

```bash
finger
```

### Planejamento de capacidade e Seleção de Recursos

* Levar em consideração qual função irá ateneder
* Qual capacidade de armazenamento utilizará
* Qual será o crescimento do sistema

**Como calcular requisitos de disco ?**

* Tamanho total
* Tipo
* Crescimento do que será hospedado
* LVM é seu amigo

**Tipos de disco ( taxa real gravação, não do bararamento )**

* Flash - 50Mb/s roteadores embarcados, pouco log, pouca gravação
* SATA - 350Mb/s baixa performance de gravação 5k RPM - 10k RPM
* SAS (padrão corporativo) - 450Mb/s boa performance de gravação 15k RPM
* SSD - 600Mb/s excelente performance de gravação/baixa latência x 32 cmd
* NVME/M2 - 6Gb/s e 64k comandos

> Evitar usar memória swap em SSD por que reduz a vida útil do disco

**Requisitos de memória**

* Tamanho de memória 
* Frequência (máquina física)

```
Java 4Gb mínimo por aplicativo
dnsmasq - 1Mb (engloba os serviços bind e dhcp de forma bem mais leve)
bind - 50Mb
dhcp - 10Mb
Apache - 20Mb
```

**CPU**

* Frequência da CPU
* Tamanho do cache L2
* Tipo de operação
       - Residencial - AMD Ryzen 7, Intel i3, i5, i7, i9 etc... 
       - Corporativos - Xeon, AMD Epyc

**Rede de comunicação**

* Velocidade (10/100/1000/10Gb/100Gb)
* Tecnologia: Cabeada, Fibra, virtual switch
* Distância: (em datacenters mentor latência = máquinas mais próximas). Hospedagem internacional é sempre mais barata

#### Troubleshoot

```bash
# Trio de ferramentas
df -a # Exibe pseudo filesystem como cgroups
df -hT
free -h
top
```

> bônus:
>
> `du -ks*` verificar espaço em uso
>
> `dmesg -T` verificar logs do kernel
>
> `ping` para verificar latência
>
> `logs`

### Hardening

**Aumento de complexidade de senhas**

```bash
# No Debian instalar lib-pamcracklib ou pwcomplexity
# Parametrizar o arquivo:
/etc/pam.d/common-password
```

**Expiração de contas de sistema e trocas de senha periódicas**

```bash
# Para verificar/alterar politicas de expiração de senhas de contas
chage
```

```bash
# Parametrizar o arquivo:
/etc/login.defs
```

**Desativando serviços desnecessários**

Deixando ativado somente os serviços que atenderão a finalidade do uso da máquina

```bash
# Restrigir quais usuários podem acessar a máquina e definir o IP a ser utilizado e alterar a porta que o serviço utilizará via acesso SSH parametrizando o arquivo
/etc/sshd
```

**Segurança por obscuridade**

Alterar porta padrão que o serviço irá utilizar

**Manter atualizações de segurança em dia**

**Com frequência salvar lista de pacotes instalados na máquina para auditoria futura**

```bash
# Debian based
dpkg --get-selections | tee <Nome-da-lista>

# Comparação futura com diff
diff -u <Nome-da-lista-1> <Nome-da-lista-2>
```

**Procurar binários SUID e SGUID que estão instalados no sistema**

Para evitar escalação de privilégio

```bash
find . -perm /4000
find . -perm /2000
```

**ULIMIT - Listar limites que usuário pode ter durante a sessão dele**

```bash
# Checa limites
ulimit -a

# Altera limites
/etc/security/limits.conf
```

**Monitorar logs e usuários**

```bash
w

last

last <USER>
```

