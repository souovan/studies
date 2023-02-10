# Camadas de gerenciamento de armazenamento

```
+----------------------------------------------------------+
|        Arquivos de sistemas, arquivos de swap            |
+----------------------------------------------------------+
        ^                         ^
        |                         |
        |   +------------------------------------+
        |   |  Volumes Lógicos: Use a piscina de |
        |   |  um grupo de volume como partições |
        |   +------------------------------------+
        |                         ^
        |                         |
+----------------------+ +-------------------------------+
| Partições: Tamanho   | | Grupo de Volume: Junta        |
| fixo de uma subseção | | diversos dispositivos de arma |
| de um dispositivo de | | zenamento para fazer uma      |
| armazenamento        | | piscina de armazenamento      |
+----------------------+ +-------------------------------+
  ^      ^                                  ^          ^
  |      |                                  |          |
  |    +---------------------------------------------+ |
  |    | Dispositivos de armazenamento: Disco rigido | |
  |    | HD externo, armazenamento em bloco          | |
  |    +---------------------------------------------+ |
  |____________________________________________________|
```

# Listar, Criar e Excluir partiçõesem discos MBR e GPT

| MBR | GPT |
| --- | --- |
| Layout - Master Boot Record | Layout EFI - GUID Partition Table |
| Pode ter até 4 partições | Pode ter até 128 Partições |
| Uma partição pode ser extendida, e ter até 15 partições | Sem limite de 2TB por partição |
| Limite de 2TB por partição | 128bit unique ID |
| Padrão antigo da Microsoft | |

* Use `gdisk -l` para ver os tipos de partição
* Use `fdisk -l` para ver os dispositivos disponíveis
* Use `lsblk -l` para listar os dispositivos de bloco do sistema
* Use `lsblk --fs` para verificar os dispositivos de bloco conectados a uma máquina e recuperar as UUIDs do sistema de arquivos
* Use `fdisk <nomedodisco>` para criar uma partição em MBR
  - `fdisk /dev/sdb`
* Use `gdisk <nome do disco>` para criar uma partição em GPT
  - `gdisk /dev/sdc`
* Use `partprobe` para atualizar a tabela de partições do kernel

> * fdisk é um favorito histórico e é compatível com partições GPT há anos.
> * gdisk e outras variantes fdisk foram inicialmente criados para dar suporte à GPT.
> * parted e a biblioteca libparted têm sido o padrão RHEL há anos.
> * O instalador Anaconda continua a usar a biblioteca libparted.
> * gnome-disk é a ferramenta gráfica padrão do GNOME, substituindo o upstream gparted.
> * Quase todos os editores do CLI são bons para scripts, e parted foi projetado para isso.

> Você não pode usar o MBR e o GPT juntos como partição no mesmo dispositivo de disco

# Criar e remover volumes físicos

* Necessário aplicar um tipo de partição LVM para uso junto com Volumes Lógicos

```bash
# Prepara o volume para ser usado com um LVM (Gerenciador de volumes lógicos)
pvcreate

# Use o comando para criar
pvcreate /dev/sdb1

# Use para ver os volumes físicos 
pvs
# ou para ver em detalhes
pvdisplay

# Use para remover um volume físico
pvremove /dev/sdb1
```

## Atribuir volumes físicos a grupos

* Crie um grupo de volume com `vgcreate`

```bash
# Cria o grupo de volume EXEMPLO com volume físico /dev/sdb1
vgcreate EXEMPLO /dev/sdb1
```

* Liste os grupos de volumes

```bash
vgdisplay EXEMPLO
# ou
vgs
```

* Estenda um Grupo de Volume

```bash
vgextend EXEMPLO /dev/sdc1 /dev/sdd1
```

# Criar e excluir volumes lógicos

* Crie um volume lógico com `lvcreate`

```bash
# Cria o volume lógico meulv1 do grupo de volumes EXEMPLO
lvcreate -L 500M -n meulv1 EXEMPLO

# Cria o volume lógico com 10 pe a partir do grupo de volumes EXEMPLO
lvcreate -l 10 -n meulv2 EXEMPLO

# Liste os grupos de volumes
lvdisplay EXEMPLO
# ou
lvs
```

# Montar sistemas de arquivos com (UUID) ou rótulo

* Montar manualmente:
  - `mount /dev/sdb1 /mnt`
* Para montar de forma automática, configuramos o arquivo `/etc/fstab`
  - Podemos montar pelo nome:`/dev/sdb2`
  - Por um rótulo (label)
  - Pela UUID: Identificação única do arquivo de sistema
* Para definir rótulos em um arquivo de sistemas:
  - Use `tune2fs -L` para arquivos de sistema ext3 ou ext4 
  - Use `xfs_admin -L` para arquivos de sistema xfs
* Use `lsblk -fi` para ver o tipo de arquivo de sistemas

# Memória SWAP

* Swap é um espaço em disco usado quando a quantidade de memória RAM está cheia. Quando um sistema Linux fica sem RAM, as páginas inativas são movidas da RAM para o espaço de Swap.
* Mais lento que RAM
* O uso de Swap indica uma má performance do seu servidor

RAM | Espaço de SWAP | Espaço de SWAP se a hibernação for permitida
--- | --- | ---
2 GB ou menos | Duas vezes a RAM | Três vezes a RAM
Entre 2 GB e 8 GB | O mesmo que a RAM | Duas vezes a RAM
Entre 8 GB e 64 GB | Pelo menos 4 GB | 1.5 vezes a RAM
Mais de 64 GB | Pelo menos 4 GB |Hibernação não recomendada

## Adicionar Swap em novas partições e volumes lógicos e alternar de forma não destrutiva

* Temos 2 formas de fazer essa tarefa:
  -  Criar uma partição e marcar tipo swap, depois formatar com o comando `mkswap <partição>`, e ativar o swap com `swapon <partição>`
  - Criar um volume lógico, e formatar com `mkswap` e ativar com `swapon`
* Ative swap com `swapon` e desative com `swapoff`
* Edite o arquivo `/etc/fstab` para o arquivo de sistemas SWAP ser montado na inicialização do sistema

```bash
# Mostrar os dispositivos de swap
swapon -s

# Mostrar o total de swap
free -m
```

