# SYSTEMD

* Configuração e controle de sistemas Linux
* É uma coleção de programas, serviços(daemons),bibliotecas, tecnologias e componentes do kernel

## Units

* Uma entidade gerenciada pelo systemd é chamada de unit(unidade)
* Uma unidade pode ser
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
```

```bash
# Mostra o status do serviço
systemctl status <servico>

# Inicia o serviço
systemctl start <servico>

# Habilita a inicialização automática do serviço
systemctl enable <servico>
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
| bg | Envia o job para o background |
| fg | Envia o job para o foreground |

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
# Veja qual comando começou o processo 
ps -ef
```

# TOP: Monitor de processos

* Mostra processos em tempo real
* Use > (filtra por memória) ou < (filtra por uso de CPU) para filtrar diferentes prioridades
* Load Average: Carga média do CPU em 1, 5 e 15 minutos (mostra a quantidade de CPUs em uso)

> Pressionando `1` na tela do comando `top` exibe a descriçãos dos CPUs 

| Estado do processo | Descrição |
| --- | --- |
| running | processo esta ativo e usando CPU |
| sleeping | processo esta esperando um evento para ser completado |
| stopped | processo está parado | 
| zombie | processo parado mas não foi removido pelo processo pai |

## KILL, KILLALL e PKKILL 

* Todo processo tem um processo pai, enquanto o processo existir
* Processos pai são responsáveis pelos processos filhos
* Quando terminar um processo pai, este processo irá limpar e eliminar os processos filhos
* Usamos sinais - veja `man 7 signals` - para gerenciar como queremos lidar com um processo


* `kill` usado para enviar um sinal para um processo
  - use `kill -l` para ver quais sinais estão disponíveis
  - `kill -sinal PID`
* `pkill` usado para enviar sinal para o processo pelo nome e outros atributos
  - `pkill -u user1`(termina todos os processos do usuario user1)
* `killall` termina o processo pelo nome
  - `killall httpd`

## NICE e RENICE

* Nice em inglês significa legal. O "nice" em Linux é uma indicação numérica para o kernel como o processo deveria ser tratado em relação a outros processos
* Quanto mais "legal", ou seja, quanto maior o nice, mais para o final da fila o processo vai. **Em Linux o nice vai do -20 ao + 19**
* **Renice** É como definimos o nice em um processo que já esteja iniciado

> * Um processo herda o niceness do processo pai
> * O dono de um processo pode aumentar o nice, mas não pode diminuir para evitar que processos filhos tenham prioridade maiores que o processo pai
> * O usuário raiz pode mudar o nice


