# Agendar tarefas usando `at` e `cron`

* `at` agenda tarefas no futuro que só aconteceram uma vez

```bash
# Instalar at
dnf install -y at

# Ativa o serviço at no boot e o inicia
systemctl enable atd
systemctl start atd

# Verifica quais atividades estão agendadas com at
atq

# Remove uma atividade agendada com at
atrm <número-da-atividade>
```

* `cron` agenda tarefas que aconteceram repetidamente

```bash
# Ativa o serviço cron no boot e o inicia
systemctl enable crond
systemctl start crond

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
# 17 *	*  *  *	root    cd / && run-parts --report /etc/cron.hourly

# Ajuda do cron
crontab --help

# Se for colocado script nas pastas listadas com o comando abaixo estes serão executados com cron com intervalo de acordo com nome do diretório
ls -l /etc | grep cron
```
# Configurar clientes de serviço de tempo

* Linux quando é iniciado lê a hora no hardware clock, geralmente reside no hardware do sistema, como uma placa de circuito integrada
* O horário do sistema é mantido pelo sistema operacional, independente do hardware clock. Quando mudamos horário do sistema, o horário do hardware clock não é modificado
* Horário de sistema é baseado em sem fuso horário, e leva em consideração horário de verão
* Ambos hardware e horário do sistema - por padrão - são mantidos em UTC - Universal Time Coordinated ( UTC é um padrão onde todas as horas são as mesmas no planeta )*

*planeta Terra. Se você se encontra em outro planeta, UTC pode não ser o horário padrão

## NTP - Network Time Protocol

* Hora de hardware pode não ser muito precisa
* NTP é a solução para manter o horário do seu servidor baseado em servidores da internet dedicados a essa atividade
* Configuraremos NTP no arquivo `/etc/chrony.conf`, que contém uma lista de servidores com protocolo de tempo pela network (NTP servers)
  - Use `systemctl status chronyd` para status do serviço NTP
* Para administrar Tempo e hora no RHEL, use o comando `timedatectl`
* Ative NTP:
  - `timedatectl set-ntp 1`

> # Epoch Time
> * Linux tempo e hora são calculados em epoch time
> * Epoch Time: Numero de segundos a partir de Janeiro 1 1970
> * Use o comando date para ler epoch:
>   - `date --date '@4294967295'`
>   - `date`: ver a data atual
>   - Use `man date` para ver diversos exemplos



