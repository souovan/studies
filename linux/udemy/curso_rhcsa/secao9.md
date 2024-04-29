# Agendar tarefas usando `at` e `cron`

* `at` agenda tarefas no futuro que **só** aconteceram uma vez
* Usuários sem privilégios só podem ver e controlar seus próprios trabalhos. O usuário root pode ver e gerenciar todos os trabalhos.

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

# O arquivo /etc/crontab tem um diagrama de sintaxe nos comentários
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

# Execução de comandos periódicos com o Anacron

O comando run-parts também executa os trabalhos diários, semanais, e mensais a partir de um arquivo de configuração `/etc/anacrontab`.

A sintaxe do arquivo `/etc/anacrontab` é diferente dos arquivos de configuração crontab regulares. O arquivo `/etc/anacrontab` contém exatamente quatro campos por linha, conforme exibido a seguir.

```
#period in days  delay in minutes  job-identifier  command
1                 5                 cron.daily     nice run-parts  /etc/cron.daily
7                 25                cron.weekly    nice run-parts  /etc/cron.weekly
@monthly          45                cron.monthly   nice run-parts  /etc/cron.monthly
```

* Period in days

Define o intervalo em dias para o trabalho ser executado em um agendamento recorrente. Este campo aceita um inteiro ou um valor macro. Por exemplo, a macro @daily é equivalente ao inteiro 1, o que significa que o trabalho é executado diariamente. Da mesma forma, a macro @weekly é equivalente ao inteiro 7, o que significa que o trabalho é executado semanalmente.

* Delay in minutes

Define o tempo que o daemon crond deve aguardar antes de iniciar o trabalho.
* Job identifier

Identifica o nome exclusivo do trabalho nas mensagens de log.
* Command

O comando a ser executado.

> **Recomendado** [Utilizar systemd.timer (`systemd.timer(5)`) em vez de cron](https://opensource.com/article/20/7/systemd-timers)
> 
> Vantagens:
> * Gerenciamento de dependências
>   - As dependências são declaradas nos arquivos de Units
> * Syntax de Calendário
>   - Calendário de eventos é mais intuitivo `man systemd.time`
>   - Pode ser auxiliado pela ferramenta `systemd-analyze calendar`
> * Logging
>   - Os Units mantém os logs no systemd journal e podem ser visualizados com `journalctl`


# Configurar clientes de serviço de tempo

* Linux quando é iniciado lê a hora no hardware clock, geralmente reside no hardware do sistema, como uma placa de circuito integrada
* O horário do sistema é mantido pelo sistema operacional, independente do hardware clock. Quando mudamos horário do sistema, o horário do hardware clock não é modificado
* Horário de sistema é baseado em sem fuso horário, e leva em consideração horário de verão
* Ambos hardware e horário do sistema - por padrão - são mantidos em UTC - Universal Time Coordinated ( UTC é um padrão onde todas as horas são as mesmas no planeta )*

*planeta Terra. Se você se encontra em outro planeta, UTC pode não ser o horário padrão

## NTP - Network Time Protocol

> A Autoridade para atribuição de números da internet (IANA) fornece um banco de dados de fuso horário público, e o comando timedatectl baseia os nomes de fuso horário nesse banco de dados. Os nomes de fusos horários da IANA são baseados no continente ou no oceano, geralmente seguidos, porém nem sempre, da maior cidade dentro da região do fuso horário. Por exemplo, a maior parte do fuso horário MT (Mountain time) dos EUA é America/Denver.

O comando `tzselect` é útil para identificar o nome do fuso horário correto. 
Esse comando faz perguntas de modo interativo ao usuário sobre o local do sistema e mostra o nome do fuso horário correto. Ele não altera a configuração de fuso horário do sistema.

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

> # YUM vs DNF
>
> * O comando yum não existe mais, mas agora é um alias apontando para o comando dnf
> * Como código-fonte do comando yum havia se tornado um pesadelo, a RedHat decidiu iniciar um novo projeto chamado dnf (Dandified Yum), seguindo a mesma sintaxe
> * A reescrita demorou vários anos
> * De acordo com vários relatórios, o comando dnf seria muito mais rápido que o yum

# Configurar um repositório de instalação local

* Após instalação do RHEL podemos instalar software de 2 formas:
  - Através de uma assinatura do RHN - Red Hat Network - usando o subscription manager
  - Através de um repositório de instalação local

```bash
# Desabilita a assinatura do RHN para usar repositório local
subscription-manager config --rhsm.manage_repos=0

# Habilita a assinatura do RHN
subscription-manager config --rhsm.manage_repos=1
```

```bash
# Para criar o repositório local é preciso criar um arquivo em /etc/yum.repos.d/ com a extensão .repo contendo:
[BaseOS]
  name=meu_BaseOS
  baseurl=https://rhel8.temweb.local/BaseOS
  enabled=1
  gpgcheck=0

[AppStream]
  name=meu_AppStream
  baseurl=http://rhel8.temweb.local/AppStream
  enabled=1
  gpgcheck=0
```

> ```bash
> # Verifica quais repositórios de instalação e atualização estão configurados
> dnf repolist
> ```

## Instalar e atualizar pacotes de software a partir da Red Hat Network

* Usamos o `subscription-manager`
  - Use a ajuda para ver comandos e navegar pelo comando
  - Use `subscription-manager register` para registrar sua máquina
  - Use `subscription-manager attach` para associar sua assinatura a sua máquina

> ```bash
> # Lista os repositórios que a máquina tem direito de usar
> subscription-manager repos
> ```

# Trabalhar com streams de módulo de pacote

* Um módulo é um conjunto de pacotes RPM que representa um componente e geralmente são instalados juntos
* Um módulo típico contém pacotes com um aplicativo, pacotes com bibliotecas de dependência específicas do aplicativo, pacotes com documentação para o aplicativo e pacotes com utilitários auxiliares
* Módulos Streams
  - Os fluxos de módulo representam versões dos componentes AppStream
  - Os fluxos de módulo podem estar ativos ou inativos. Os fluxos ativos fornecem ao sistema acesso aos pacotes RPM dentro do fluxo de módulo específico

> Streams de Módulo são versões diferentes de cada módulo

```bash
# Listar todos módulos
dnf module list postgresql

# Listar detalhes de módulos
dnf module info postgresql

# Instalar um módulo
dnf module install postgresql

# Para mudar a versão padrão usada do módulo
dnf module enable postgresql:12

# Para selecionar uma versão
dnf module install postgresql:9.6

# Remover o módulo
dnf module remove --all postgresql

# Resetar a versão padrão
dnf module reset postgresql
```

# Modificar o carregador de inicialização do sistema

* GRUB2 garante que Linux kernel pode ser carregado
* Inicia todos os dispositivos - drivers necessários para inicialização de seu servidor Linux
* Editamos o GRUB2 no arquivo `/etc/default/grub`
* Escrevemos essas mudanças para o arquivo princial com o comando:
  - `grub2-mkconfig -o /boot/grub2/grub.cfg`

> Memorizar o comando `grub2-mkconfig -o /boot/grub2/grub.cfg` para o exame

* Use `cat /etc/default/grub` para ver e alterar as variáveis

| **GRUB_TIMEOUT** | define o tempo de espera de inicialização |
| --- | --- |
| GRUB_DISTRIBUTOR | contém o nome da distribuição |
| GRUB_DEFAULT | especifica a entrada do menu padrão |
| GRUB_DISABLE_SUBMENU | permite(falso) ou não (verdadeiro) a exibição de um submenu |
| GRUB_TERMINAL_OUTPUT| define o dispositivo de entrada e saída do termina |
| GRUB_SERIAL_COMMAND | configura a porta serial |
| **GRUB_CMDLINE_LINUX** | específica os argumentos de linha de comando adicionados às entradas de menu para o kernal Linux |
| GRUB_DISABLE_RECOVERY | define as entradas podem ser selecionadas no modo de recuperação por meio de uma linha separada (falso) ou apenas a entrada padrão (verdadeiro) |




