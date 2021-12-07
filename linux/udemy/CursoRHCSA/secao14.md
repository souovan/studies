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

