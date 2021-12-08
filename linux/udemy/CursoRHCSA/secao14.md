# Kernel Linux

* O Kernel Linux é livre e de código aberto, monolítico, modular, muiltitarefa, kernel do sistema operacional do tipo Unix
* Foi criado em 1991 por Linus Torvalds
* Veja a versão e informações do Kernel usando o comando `uname`
* O Kernel Linux é o principal componente de um sistema operacional Linux e é a interface principal entre o hardware de um computador e seus processos. Ele se comunica entre os 2, gerenciando os recursos de forma mais eficiente possível
* Os namespaces e grupos de controle são um recurso do Kernel Linux

## Linux Namespace(Nome de Espaços)

* Os namespaces particionam os recursos do kernel de forma que um conjunto de processos veja um conjunto de outro conjunto de processos como diferente
* Exemplos de tais recursos são IDs de processo(PID), IDs de usuário(userid), nomes de arquivo e alguns nomes associados ao acesso à rede e comunicação entre processos(net)
* Um sistema Linux começa com um único namespace em cada tipo, usado por todos os processos

> `lsns --help` do pacote _util-linux_ pode listar todos os diferentes tipos de namespaces em seu sistema Linux

## Linux Control Groups(Grupos de Controle)

* Conhecidos como "cgroups"
* Recurso do Kernel Linux que limita, considera e isola o uso de recursos (CPU, memória, disco I/O(entrada e saída) de rede de uma coleção de processos)

## Linux Containers no RHEL8/CentOS8

```
                 Admin ou
                 Developer                👧
               ____________________________|________________________________
              |  __________________________꣺______________________________  |
              | |                   Shell do usuário                      | |
              | |_________________________________________________________| |
              | __________________________     ______________  ___________  |
  NAMESPACE   || Gerenciador de container |   | Processos de || Processos | |
  do usuário  ||       ____________       |-->| containers   || regulares | |
              ||      |___PODMAN__ |      |   |______|_______||_____|_____| |
              ||____________|_____________|          |              |       |
              |             |                        |              |       |
              |_____________|________________________|______________|_______|
                            |                        |              |        
                ____________|________________________|______________|____  
               |  _________ ꣺ _______________________|______________꣺___ |
               | | drivers | | ________________  ____꣺____  _________   ||
               | |_________| || NAMESPACE      || CGROUPS  || SELINUX | || 
  KERNEL       |             ||________________||__________||_________| || 
               |             |__________________________________________|| 
               |_________________________________________________________| 
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

```sh
#Puxa imagem do registro local ou remoto
podman pull
```

```sh
#Obtém informação pela ID ou nome do objeto (container, image, network, volume)
podman inspect <nome_do_objeto>
```

```sh
#Inicia um container a partir de uma imagem
podman run
```

```sh
#Cria uma imagem a partir das mudanças feitas no container
podman commit
```

```sh
#Adiciona um ou mais nomes adicionais a imagens locais
podmain tag
```

```sh
#Empurra uma imagem para um repositório de imagens de containers remotos
podman push
```

```sh
# (utilizado da máquina host do container) Lista processos em execução dentro do container
podman top <nome_do_container> hpid pid user args
```

```sh
# exibe containers em execução
podman ps

# exibe todos containers em execução (até os parados)
podman ps -a
```

```sh
# remove um container
podman rm <nome_do_container>

# remove todos containers
podman rm -a
```

> ```sh
> # (executado dentro do container) Sai do container sem matá-lo (encerrar o processo dele)
> CTRL+p
> CTRL+q
> ```

# Ferramentas de containers no RHEL8/CentOS8

* podman - É um gerenciador de container runtime e ferramenta mais eficientes que o docker. Integrado com buildah
* buildah - criar imagens de container pela linha de comando ou por Containerfiles(Dockerfiles)
* skopeo - copia containers e imagens entre diferentes tipos de armazenamento de containers

```
            ___________________
           |                   |
           |  Image registry   |
           |___________________|
                   ^            
                   |       skopeo
               ____|_____
              |          |
              |  Podman  |
              |__________|
                  |  |
     Buildah      |  |    ____________
    ________      |  \-->|            |
   |        |<----/  |   | containers |
   | Images |        |   |____________|
   |________|        |    ____________
                     \-->|            |
                         |  kernel    |
                         |____________|
```
