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





