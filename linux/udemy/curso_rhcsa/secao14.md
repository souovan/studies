# Kernel Linux

* O Kernel Linux é livre e de código aberto, monolítico, modular, muiltitarefa, kernel do sistema operacional do tipo Unix
* Foi criado em 1991 por Linus Torvalds
* Veja a versão e informações do Kernel usando o comando `uname`
* O Kernel Linux é o principal componente de um sistema operacional Linux e é a interface principal entre o hardware de um computador e seus processos. Ele se comunica entre os 2, gerenciando os recursos de forma mais eficiente possível
* Os namespaces e grupos de controle são um recurso do Kernel Linux

**O Red Hat Enterprise Linux dá suporte a contêineres usando as seguintes tecnologias principais:**

* Linux Control Groups
  - Conhecidos como "cgroups"
  - Recurso do Kernel Linux que limita, considera e isola o uso de recursos (CPU, memória, disco I/O(entrada e saída) de rede de uma coleção de processos)

* Linux Namespace
  - Os namespaces particionam os recursos do kernel de forma que um conjunto de processos veja um conjunto de outro conjunto de processos como diferente
  - Exemplos de tais recursos são IDs de processo(PID), IDs de usuário(userid), nomes de arquivo e alguns nomes associados ao acesso à rede e comunicação entre processos(net)
  - Um sistema Linux começa com um único namespace em cada tipo, usado por todos os processos

> `lsns --help` do pacote _util-linux_ pode listar todos os diferentes tipos de namespaces em seu sistema Linux

* SELinux e Seccomp (modo Secure Computing)
  - para reforçar os limites de segurança

## Linux Containers no RHEL8/CentOS8

```
                 Admin ou
                 Developer                👧
              +----------------------------|--------------------------------+
              | +--------------------------꣺------------------------------+ |
              | |                   Shell do usuário                      | |
              | +---------------------------------------------------------+ |
              |+--------------------------+   +--------------++-----------+ |
  NAMESPACE   || Gerenciador de container |   | Processos de || Processos | |
  do usuário  ||      +------------+      |-->| containers   || regulares | |
              ||      |___PODMAN__ |      |   +------|-------++-----|-----+ |
              |+------------|-------------+          |              |       |
              +-------------|------------------------|--------------|-------+        
               +------------|------------------------|--------------|----+ 
               | +---------+꣺+-----------------------|--------------꣺---+|
               | | drivers | |+----------------+ +---꣺-----++---------+ ||
               | +---------+ || NAMESPACE      || CGROUPS  || SELINUX | || 
  KERNEL       |             |+----------------++----------++---------+ || 
               |             +------------------------------------------+| 
               +---------------------------------------------------------+ 
```

## Passo importante quando usando o Podman no RHEL 8

Para poder user o podman de forma rootless, ou seja, com um usuário que não seja o usuário raiz, é importante carregar as variáveis de ambiente de forma correta.

>IMPORTANTE:
> Quando mudar para um usuário comum usando o podman, use `su - worker` quando acessar o usuário worker, ou diretamente no ssh com `ssh srv0 -l worker`. Desta forma estaremos carregando o ambiente de trabalho de forma correta.

# Comandos importantes

>```sh
># Instala a ferramenta ps
>yum install -y procps-ng
>```

>```sh
># Instala as ferramentas de configuração avançadas de roteamento e rede
># que habilita o comando ss -tuna para checar as conexões de rede atreladas ao container
>yum install -y iproute
>```

| Comando |	Descrição |
--- | ---
`podman info` | Exibe informações de configuração do podman
`podman build` | 	Compila uma imagem de contêiner com um arquivo de contêiner.
`podman run` |	Executa um comando em um novo contêiner.
`podman images` |	Lista imagens no armazenamento local.
`podman ps` |	Exibe informações sobre contêineres.
`podman inspect` | Exibe a configuração de um contêiner, imagem, volume, rede ou pod.
`podman pull` |	Faz download de uma imagem de um registro.
`podman tag` | Adiciona um ou mais nomes adicionais a imagens locais
`podman push` | Faz upload de uma imagem para um registry remoto
`podman cp` |	Copia arquivos ou diretórios entre um contêiner e o sistema de arquivos local.
`podman exec` |	Executa um comando em um contêiner em execução.
`podman rm` |	Remove um ou mais contêineres.
`podman rmi` |	Remove uma ou mais imagens armazenadas localmente.
`podman search` |	Pesquisa uma imagem em um registro.

```sh
# (utilizado da máquina host do container) Lista processos em execução dentro do container
podman top <nome_do_container> hpid pid user args
```

> Para mais informações consultar `man -k podman-`

> ```sh
> # (executado dentro do container) Sai do container sem matá-lo (encerrar o processo dele)
> CTRL+p
> CTRL+q
> ```

# Ferramentas de containers no RHEL8/CentOS8

* podman - É um gerenciador de container runtime e ferramenta mais eficientes que o docker. Integrado com buildah
* buildah - criar imagens de container pela linha de comando ou por Containerfiles(Dockerfiles)
* skopeo - inspeciona, copia, exclui e assina imagens.

```        
           +-------------------+
           |  Image registry   |
           +-------------------+
                   ^            
                   |       skopeo
                   |
              +----------+
              |  Podman  |
              +----------+
                  |  |
     Buildah      |  |    
                  |  +-> +------------+
   +--------+ <---+  |   | containers |
   | Images |        |   +------------+
   +--------+        |   
                     +-> +------------+
                         |  kernel    |
                         +------------+
```

# Rootless containers

* Quer dizer executar containers sem ser o usuário root
* Como um usuário rootless, as imagens de container são armazenadas em seu diretório inicial `$HOME/.local/share/containers/storage/`, enquanto o do usuário _root_ fica em `/var/lib/containers`
* Se precisar configurar seu ambiente de container rootless, edite os arquivos de configuração em seu diretório inicial `$HOME/.config/containers/`
* Os arquivos de configuração incluem **storage.conf** (para configurar o armazenamento) e **libpod.conf** (para diversas configurações de container). Você também pode criar um aquivo **registries.conf** para identificar os registros de container disponíveis quando você executa `podman pull` ou `podman run`

* Para verificar se a configuração rootless, você pode executar comandos dentro do namespace modificado do usuário com o comando:
    - `podman unshare cat /proc/self/uid_map`
* Mapas para usuários são configurados em:
    - `/etc/subuid`
    - Note que o usuário _root_ não entra nessa mapeação, ao qual é feita para usuários de containers rootless
    - No RHEL8 o arquivo `/etc/subuid` é populado de forma automática quando criamos um usuário

# Configuração de busca para registros remotos

```sh
# Arquivo de configuração do root fica em: 
/etc/containers/registries.conf

# Arquivo de configuração rootless fica em:
~/.config/containers/registries.conf
```

A Red Hat não recomenda usar a opção `--password` para fornecer a senha diretamente, pois ela armazena a senha nos arquivos de log.
Em vez disso usar `--password-stdin` que lê a senha de stdin

```
podman login --username <username> --password-stdin <registry_url>
```

Para verificar se você está conectado a um registro
```
podman login quay.io --get-login
```

> Dica: copie os arquivos de configuração do `/etc/containers/` do usuário _root_ retirando todas linhas que iniciam com comentário:
> 
> `grep -v "^#" /etc/containers/registries.conf > ~/.config/containers/registries.conf`

# Variáveis de ambiente

```sh
# Parametro -e(environment) sobe o container passando variáveis de ambiente para ele 
podman run -it -e COLOR=blue
```
# Armazenamento persistente com volumes

```
 +------------------------------------------------+
 |    /var/lib/mysql +-----------+ 127.0.0.1:3306 | IP-DA-VM:3306
 |          |      | | mariadb   |                |
 |          |      | | container |                |
 |      +---+      | +-----------+                |
 |      |          |                              |
 |      v          |                              |
 |     Bind Mount  +----------------> volume      |
 |  /home/worker/mariadb                 |        |
 |        |          +-------------------+        |
 |        |          |                            |
 | +------v----------|----+                       |
 | | Arquivo de +----v---+|                       |
 | | Sistemas   | Volume |+-----------------------|
 | |            | podman ||        Rede           |
 | |            +--------+|                       |
 | +----------------------+-----------------------|
 | |        CPU           |        Memória        |
 +-+----------------------+-----------------------+       
 ```

# VOLUME

> Mais eficiente que bind e muitas vezes é a forma recomendada

* `podman run -d --name myvol -v myvol:/var/lib/mysql -e MYSQL_USER=user -e MYSQL_PASSWORD=pass -e MYSQL_DATABASE=db -p 3306:3306 rhel8/mariadb-103`

# BIND

* `mkdir -p /home/worker/mysql`
* `podman run -d --name bindvol -v /home/worker/mysql:/var/lib/mysql:Z -e MYSQL_USER=user -e MYSQL_PASSWORD=pass -e MYSQL_DATABASE=db -p 3306:3306 rhel8/mariadb-103`

## Comandos interessantes

```sh
podman inspect -f "{{.Mounts}}" <nome ou id do container>

podman volume list

podman volume inspect <nomedovolume>

podman inspect <nomedovolume>
```

> **Um dos comandos mais importantes para troubleshoot de containers**
>
> `podman inspect`
> 
> ou
>
> `podman inspect -f "{{.Chave}}"` para filtrar o retorno pela chave ou chaves `{{.Chave.Chave.Chave}}`

# 

> CMD define comandos e/ou parâmetros padrão para um container. CMD é uma instrução que é melhor se você precisar de um comando padrão que os usuários possam facilmente substituir
>
> Exemplo:
>
> `podman inspect -f "{{.Config.Cmd}}" meuweb`
> 
> `[/bin/sh -c httpd -D FOREGROUND]`

# Executar um serviço em um container

```sh
# lança um container com imagem universal base redhat
podman run -it -d ubi

# iniciar processo dentro do container
podman exec -it <id_container> bash

# dentro do container instalar o apache
yum instal -y httpd

# sair do container
exit

# criar imagem do container
podman commit <id_container> meuweb

# modificar comando inicial do inicio do container que é obtido com (podman inspect -f "{{.Config.Cmd}}" meuweb) para que seja executado o servidor apache no inicio do container
podman run -it -d -p 8080:80 meuweb /bin/sh -c "httpd -D FOREGROUND"

# salvar imagem com comando que inicia o container atualizando nossa imagem (meuweb)
podman commit <id_container> meuweb

# fazer tag da imagem
podman tag localhost/meuweb quay.io/souovan/meuweb

# fazer login no repositório remoto
podman login quay.io

# subir imagem para o repositório remoto
podman push quay.io/souovan/meuweb
```

# Iniciar container automaticamente como serviço do systemd

>```sh
># Descompactar arquivo
>tar -xzvf meusite.tar.gz
>
># Lançar um container pré configurado que executa o apache
>podman run -it -d -p 8080:80 -v /home/worker/meusite:/var/www/html:Z --name meusite localhost/meuweb
>
># Configura-lo como serviço do systemd
># mudar para o diretório
>cd ~/.config/systemd/user/
>
># criar o arquivo (podman generate systemd --help)
>podman generate systemd --new --files --name meusite
>
># o arquivo gerado é: container-meusite.service
># e fica no diretório:  ~/.config/systemd/user/
>
># execute systemctl com parametro --user para ter acesso como usuario ao systemctl
># ativa o serviço
>systemctl --user start container-meusite.service
>
># habilita o serviço no boot
>systemctl --user enable container-meusite.service
>
># é preciso habilitar (loginctl --help) para que o container inicie automáticamente no boot do sistema caso contrário o container só inicia quando for feito login na conta do usuário
>loginctl enable-linger worker
>```

Também é possível configurar containers `root` com systemd
O processo é semelhante ao anterior com as exceções:
* não criar usuário dedicado para o gerenciamento de containers
* o arquivo de unit deve estar no diretrório `/etc/systemd/system` em vez de `~/.config/systemd/<user>`
* utilizar o comando `systemd` sem a opção `--user`
* não executar `loginctl enable-linger`como `root`

