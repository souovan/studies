# SYSTEMD

* Configuração e controle de sistemas Linux
* É uma coleção de programas, serviços(daemons),bibliotecas, tecnologias e componentes do kernel

## Units

* Uma entidade gerenciada pelo systemd é chamada de unit(unidade)
* Uma unidade pode ser `.service` `.socket` `.path`
  - Serviço, socket, dispositivo, um ponto de montagem, arquivo swap, um alvo de inicialização

```bash
# Para mais informações
man systemd.unit
```

## SYSTEMCTL: gerenciar o SYSTEMD

* Usado para verificar o status e fazer modificações no systemd

```bash
# Mostra todas unidades ativas e carregadas
systemctl list-units

# Lista todas as unidades instaladas, carregadas ou não
systemctl list-unit-files

# Filtra pelo tipo de unidade
systemctl list-units --type=service

# Alguns serviços tem dependencias de outros, para lista-las
systemctl list-dependencies <unit>
```

```bash
# Mostra o status do serviço
systemctl status <servico>

# Inicia o serviço
systemctl start <servico>

# Habilita a inicialização automática do serviço
systemctl enable <servico>
```

Alguns serviços podem conflitar com outros para evitar que o serviço seja iniciado acidentalmente pode se utilizar **Masking**

```
# O mascaramento cria um link nos diretórios de configuração para o arquivo /dev/null que impede que o serviço seja iniciado.
systemctl mask sendmail.service
```

## Comandos para reiniciar e desligar

```bash
# Reinicia o servidor e é a forma recomendada
systemctl reboot

# Desliga direto como se fosse arrancado da tomada
systemctl halt

# Desliga de forma graciosa
systemctl poweroff
```

## Targets do SYSTEMD

```bash
# Para mais informações
man systemd.target
```

* Targets mais importantes
  - `graphical.target` Target com interface gráfica
  - `multi-user.target` Target de linha de comando
  - `rescue.target` Inicia o sistema como usuário único

```bash
# Usar um target de forma imediata não persistente a reinicialização
systemctl isolate multi-user.target

# Mudar um target de forma persistente
systemctl set-default graphical.target

# Verificar qual target está configurado
systemctl get-default
```

# Alterar password do usuário root

* Na tela do grub apertar tecla `e`;
* Na tela seguinte ir até a linha que começa com linux e pressionar `ctrl + e` para ir ao final da linha;
* Completar a linha com `rd.break` e apertar `ctrl + x`
* Remontar o diretório sysroot com `mount -o remount,rw /sysroot` aperte `enter`;
* Tornar o diretório sysroot como diretório raiz `chroot /sysroot/` aperte `enter`;
* Troque a senha do usuário root com `passwd`;
* Atualize as permissões do SELinux com `touch /.autorelabel`;
* Digite `exit` e pressione `enter`;
* Digite `exit` e pressione `enter` novamente para que o sistema reinicie.

# Jobs

```bash
# Exibe os jobs em execução
jobs
```

| & | Inicia o comando no background |
| --- | --- |
| CTRL+C | Cancela o job |
| CTRL+D | Não espera o input do usuário |
| CTRL+Z | Para o job temporariamente |
| bg %n | Envia o job **n** (obtido da listagem do comando jobs) para o background |
| fg %n | Envia o job **n** (obtido da listagem do comando jobs) para o foreground |

## Processos

* PID: identificação única de um processo(Process ID)
  - Usado para manipular um processo
  - Registrados na ordem que são criados
  - Podemos usar `ps`, `pgrep` e `pidof` para achar o PID do processo

```bash
# Mostra a visão geral de todos os processos
ps aux
#  |||
#  ||mostra processos que não sejam controlados pelo terminal também
#  |mostra o usuário
#  mostra todos os processos
```

## Informações importantes do comando `ps aux`

| Cabeçalho | Descrição |
| --- | --- |
| USER | Usuário dono do processo |
| PID | Process ID |
| %CPU | Uso de CPU pelo processo |
| %MEM | Uso de memória pelo processo |
| START | Hora em que o processo foi iniciado |
| COMMAND | Comando que iniciou o processo |
| NI Se utilizando `ps lax` | Prioridade do processo |

```bash
# Ache o PID do processo pelo nome
pgrep sshd
# ou
pidof sshd
```

```bash
# Liste os processos do usuário van
pgrep -l -u van
```

```bash
# Veja qual comando começou o processo 
ps -ef
```

# TOP: Monitor de processos

* Mostra processos em tempo real
* Use > (filtra por memória) ou < (filtra por uso de CPU) para filtrar diferentes prioridades
* Load Average: Carga média do CPU em 1, 5 e 15 minutos (mostra a quantidade de CPUs em uso)

> Pressionando `1` na tela do comando `top` exibe a descriçãos dos CPUs
> Para uma visão mais parecida com o HTOP pode ser usada a combinação das teclas **`l t m`** e a configuração pode ser salva para o arquivo /home/.config/procps/toprc pressionando **SHIFT+w**

| Estado do processo | Descrição |
| --- | --- |
| running | processo esta ativo e usando CPU |
| sleeping | processo esta esperando um evento para ser completado |
| stopped | processo está parado | 
| zombie | processo parado mas não foi removido pelo processo pai |

## Sinais de gerenciamento de processo fundamentais

| Sinal	| Name | Definição
| --- | --- | --- |
| 1 |	HUP |	Hangup: comunica a finalização do processo de controle de um terminal. Também solicita a reinicialização do processo (recarregamento da configuração) sem terminá-lo. |
| **2** |	**INT** |	Keyboard interrupt: faz com que o programa termine. Pode ser bloqueado ou manipulado. Enviado pressionando a combinação de teclas INTR (interrupção) (**Ctrl+c**). |
| **3**	| **QUIT** |	Keyboard quit: semelhante a SIGINT, adiciona um despejo do processo ao terminar. Enviado pressionando a combinação de teclas QUIT (**Ctrl+\\**). |
| **9** |	**KILL** |	Kill, unblockable: faz com que o programa termine abruptamente. Não pode ser bloqueado, ignorado nem manipulado. É constantemente fatal. |
| 15 | padrão | 	TERM	Terminate: faz com que o programa termine. Diferente de SIGKILL, pode ser bloqueado, ignorado ou manipulado. A maneira "limpa" de solicitar que um programa seja encerrado. Ele permite que o programa conclua as operações essenciais e faça a autolimpeza antes do encerramento. |
| 18 |	CONT |	Continue: enviado a um processo para que ele seja retomado se estiver parado. Não pode ser bloqueado. Mesmo se for manipulado, sempre fará o processo continuar. |
| 19 |	STOP |	Stop, unblockable: suspende o processo. Não pode ser bloqueado nem manipulado. |
| **20** |	**TSTP** |	Keyboard stop: diferente de SIGSTOP, ele pode ser bloqueado, ignorado ou manipulado. Enviado pressionando a combinação de teclas de suspensão (**Ctrl+z**). 

> Os números de sinalização variam entre plataformas de hardware Linux, mas os nomes de sinalização e seus significados são padrão. É aconselhável usar nomes de sinalização em vez de números ao sinalizar. Os números acima são para sistemas de arquitetura x86_64

## KILL, KILLALL e PKKILL 

* Todo processo tem um processo pai, enquanto o processo existir
* Processos pai são responsáveis pelos processos filhos
* Quando terminar um processo pai, este processo irá limpar e eliminar os processos filhos


* `kill` usado para enviar um sinal para um processo
  - use `kill -l` para ver quais sinais estão disponíveis
  - `kill -sinal PID`
* `pkill` usado para enviar sinal para o processo pelo nome e outros atributos
  - `pkill -u user1`(termina todos os processos do usuario user1)
* `killall` termina o processo pelo nome
  - `killall httpd`
 
> É uma boa prática enviar **SIGTERM** primeiro, depois tentar **SIGINT** e, somente se os dois falharem, tentar novamente com o **SIGKILL**

## NICE e RENICE

* Nice em inglês significa legal. O "nice" em Linux é uma indicação numérica para o kernel como o processo deveria ser tratado em relação a outros processos
* Quanto mais "legal", ou seja, quanto maior o nice, mais para o final da fila o processo vai. **Em Linux o nice vai do -20 ao + 19**
* **Renice** É como definimos o nice em um processo que já esteja iniciado

> * Um processo herda o niceness do processo pai
> * O dono de um processo pode aumentar o nice, mas não pode diminuir para evitar que processos filhos tenham prioridade maiores que o processo pai
> * O usuário raiz pode mudar o nice



# Gerenciar perfis de ajuste

* Você pode criar ou modificar perfis ajustados (tuned profiles) para otimizar o desempenho do sistema para o caso de uso desejado.

```bash
# Instale e habilite o Tuned (rhel 8 vem instalado por padrão perfil workstation)
dnf install -y tuned
```

* Tuned fornece vários perfis predefinidos para casos de uso típicos. Você também pode criar, modificar e excluir perfis.

## Perfis fornecidos com o tuned

* Perfis de economia de energia
* Perfis de aumento de desempenho(inclui):
  - Baixa latência para armazenamento e rede
  - Alta taxa de transferência para armazenamento e rede
  - Desempenho da máquina virtual
  - Desempenho do host de virtualização

### Como buscar ajuda

```bash
tuned-adm --help

# Exibe profile tuned ativo
tuned-adm active

# Exibe lista de profiles disponiveis e profile ativo
tuned-adm list

man 5 tuned.conf

man 7 tuned-profiles (descrição dos perfis de ajuste)

man 8 tuned

man 8 tuned-adm
```

### Arquivos principais

```bash
/etc/tuned/

/usr/lib/tuned/
```

## Tuning estático e dinâmico

* Tuning Estático: consiste de aplicações pré-definidas
* Tuning Dinâmico: tuned é ajustado de acordo com informação do sistema
* Edite `/etc/tuned/tuned-main.conf` mude `dynamic_tinung para` 1
  * Caso necessário, ajuste intervalos de ajuste em segundos modificando a opção `update_interval`no arquivo acima
* E use `systemctl restart tuned`para aplicar mudanças
* Para ver as mudanças em tempo real:
  * `tail -f /var/log/tuned/tuned.log`

```bash
# Comandos interessantes
tuned-adm --help # ver lista de comandos

tuned-adm list # ver lista de perfis

tuned-adm active # ver perfil ativo

tuned-adm recommend # ver perfil recomendado

tuned-adm profile throughput-performance # escolher qual perfil deveria ser usado utilize assim

# Checar se o parametro de kernel definido no profile está correto
sysctl <kernel parameter>
```

# Arquivos de Log

* System daemons, kernel, e aplicativos todos emitem dados operacionais que são logados.
* Em resumo a vida de um log é ser pesquisado, filtrado, resumido, analizado, comprimido, arquivado e eventualmente descartado.
* Um arquivo de log geralmente é uma linha de texto que contém propriedades tais como data, tipo e severidade do evento, e nome e ID (PID) do processo.
* Quando algo da errado, os logs de daemons é onde vamos olhar por erros, bugs, e problemas de segurança

## JOURNALD

* **Com a introdução do systemd, o systemd-journald foi introduzido**. O journald é altamente integrado com o systemd.
* O journald coleta mensagens, armazena as mensagens de forma comprimida e indexada em um formato binário
* Podemos usar o comando "systemctl status" para ver o status do serviço junto com mensagens de log
* Mensagens não são persistentes por padrão
* Use o cmando "journalctl" para ver as mensagens no jornal de log

```bash
# Use para ver logs
journalctl
# Use opção "-u" para ver logs de uma unit específica
journalctl -u httpd

journalctl --disk-usage

journalctl --list-boots

journalctl -b 0 -u ssh

journalctl --since=yesterday --until=now

journalctl -o verbose
```



## RSYSLOGD

* Mensagens são enviadas para o serviço rsyslogd para serem salvas em arquivos de texto
* Mensagens são escritas para o diretório `/var/log` por padrão
* Vantagens do rsyslog são habilidade de usar uma central de logs e módulos para filtrar as mensagens de log



* Para especificar como cada mensagem é gerenciada, rsyslog usa:
  * **Facility**: Categoria da informação que deve ser logada
  * **Priority**: Severidade da mensagem de log a ser logada. Prioridade definida e todas acimas são logadas
  * **Destiny**: Para onde as mensagens serão logadas
* Configuradas no arquivo `/etc/rsyslog.conf`e `/etc/rsyslog.d`

```bash
# Use para lista das facilidades e prioridades
man 5 rsyslog.conf
```

# Logrotate

* Usado para prevenir o seu disco de encher com logs
* Depois que logs são reciclados, eles serão apagados permanentemente.(Verifique sempre a politica de logs de sua empresa)
* Use também o `/etc/logrotate.d` para fazer configurações adicionais
* Use `man logrotate` para maiores detalhes

> O comando `logger` envia mensagens para o serviço do rsyslog. Por padrão, o comando `logger` envia a mensagem para o tipo de usuário com a prioridade notice (`user.notice`), a menos que especificado de outra forma com a opção `-p`

# Armazenamento de diário do sistema

Por padrão, o RHEL armazena o diário do sistema no diretório /run/log e o sistema limpa o diário do sistema após uma reinicialização. Você pode alterar as configurações do serviço systemd-journald no arquivo `/etc/systemd/journald.conf` para manter os diários após uma reinicialização.

O parâmetro Storage no arquivo /etc/systemd/journald.conf define se os diários do sistema devem ser armazenados de maneira volátil ou persistente em uma reinicialização. Defina esse parâmetro como `persistent`, `volatile`, `auto` ou `none` desta forma:

|     |     |
| --- | --- |
| persistent | armazena os diários no diretório /var/log/journal, que é mantido nas reinicializações. Se /var/log/journal não existir, o serviço systemd-journald criará o diretório. |
| volatile   | armazena os diários no diretório /run/log/journal volátil. Como o sistema de arquivos /run é temporário e existe somente na memória de tempo de execução, os dados armazenados nele, inclusive os diários do sistema, não são mantidos na reinicialização. |
| auto       | se o diretório /var/log/journal existir, o serviço systemd-journald usará o armazenamento persistente, caso contrário, usará o armazenamento volátil. Essa ação será o padrão se o parâmetro Storage não estiver definido. |
| none       | não usa nenhum armazenamento. O sistema descarta todos os logs, mas você ainda pode encaminhar os logs. |

# Transferir de forma segura arquivos entre sistemas

> [A Red Hat Não recomenda o uso de scp](https://access.redhat.com/security/cve/cve-2020-15778)
>
> Em vez disso, usar outros utilitários, como os comandos `sftp` (man sftp) ou `rsync`, para copiar arquivos de ou para um host remoto.

## rsync

Uma vantagem do comando rsync é que ele copia arquivos entre um sistema local e um sistema remoto com segurança e eficiência. Enquanto a sincronização inicial do diretório leva mais ou menos o tempo de uma cópia, as sincronizações subsequentes copiam somente as diferenças pela rede, acelerando significativamente as atualizações.

```
# Para simular a execução do comando sem realizar a transferência (dry run)
rsync -n

# Para transferir a servidor remoto
rsync -av <file> <user>@<server>:<remote-path>
```






