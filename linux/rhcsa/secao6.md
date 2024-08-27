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

# Listar, Criar e Excluir partições em discos MBR e GPT

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

>[!IMPORTANT]
> * `fdisk` é um favorito histórico e é compatível com partições GPT há anos.
> * `gdisk` e outras variantes fdisk foram inicialmente criados para dar suporte à GPT.
> * `parted` e a biblioteca libparted têm sido o padrão RHEL há anos.
> * O instalador Anaconda continua a usar a biblioteca libparted.
> * gnome-disk é a ferramenta gráfica padrão do GNOME, substituindo o upstream gparted.
> * Quase todos os editores do CLI são bons para scripts, e `parted` foi projetado para isso.

>[!WARNING]
> Você não pode usar o MBR e o GPT juntos como partição no mesmo dispositivo de disco

>[!TIP]
> Se forem necessárias mais de quatro partições em um disco com particionamento MBR, crie três partições primárias e uma estendida. A partição estendida serve como um contêiner no qual você pode criar várias partições lógicas.

```bash
# Criação de particões com parted (sem espeficicar subcomando entra no modo interativo)
[root@host ~]# parted /dev/vdb
GNU Parted 3.4
Using /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted)

# Depois utilize mkpart para criar uma partição primária ou estendida
(parted) mkpart
Partition type?  primary/extended? primary

# Para listar os tipos de filesystem compatíveis
parted /dev/vdb help mkpart

# Indique o tipo de filesystem
File system type?  [ext2]? xfs

# Especifique o setor do disco em que a nova partição será iniciada.
# s para setor
# B para byte
# MiB , GiB ou TiB (potências de 2)
# MB , GB ou TB (potências de 10)
Start? 2048s
End? 1000MB
(parted) quit
Information: You may need to update /etc/fstab.
```
Execute o comando `udevadm settle`. Esse comando aguarda que o sistema detecte a nova partição e crie o arquivo de dispositivo associado no diretório /dev.

É possível criar a particação com um unico comando:
```
[root@host ~]# parted /dev/vdb mkpart primary xfs 2048s 1000MB
```

O esquema de GPT também usa o comando parted para criar partições. Com o esquema de GPT, cada partição recebe um nome.
```
[root@host ~]# parted /dev/vdb
GNU Parted 3.4
Using /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted)

(parted) mkpart
Partition name?  []? userdata

File system type?  [ext2]? xfs

Start? 2048s
End? 1000MB
(parted) quit
Information: You may need to update /etc/fstab.
```
Execute o comando `udevadm settle`. Esse comando aguarda que o sistema detecte a nova partição e crie o arquivo de dispositivo associado no diretório /dev.

## Excluir partições `parted`
```
[root@host ~]# parted /dev/vdb
GNU Parted 3.4
Using /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted)

# Identifique o número da partição
(parted) print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size   File system  Name       Flags
 1      1049kB  1000MB  999MB  xfs          usersdata

# Exclua a partição e saia de parted. 
(parted) rm 1
(parted) quit
Information: You may need to update /etc/fstab.
```

É possível excluir uma partição em um único comando:
```
[root@host ~]# parted /dev/vdb rm 1
```

# Criação de sistema de arquivos

Após a criação de um dispositivo de bloco, o próximo passo é adicionar um sistema de arquivos a ele. O Red Hat Enterprise Linux suporta vários tipos de sistema de arquivos, e XFS é o padrão recomendado.

```
[root@host ~]# mkfs.xfs /dev/vdb1
meta-data=/dev/vdb1              isize=512    agcount=4, agsize=60992 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=243968, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=1566, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

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

## Remover de grupos de volumes
Use o comando `vgremove VG-NAME` para remover um grupo de volumes que não é mais necessário.

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

## Estender e reduzir LVM
Uma das vantagens de usar volumes lógicos é aumentar seu tamanho sem passar por tempo de inatividade.

```
# Aumenta o tamanho do volume lógico em 500MB
lvextend -L +500M /dev/vg01/lv01
```

###  Extensão de um sistema de arquivos XFS para o tamanho do volume lógico
```
# O comando xfs_growfs ajuda a expandir o sistema de arquivos para ocupar o LV estendido.
xfs_growfs /mnt/data/
```

>[!IMPORTANT]
> O sistema de arquivos de destino deve ser montado antes de você usar o comando xfs_growfs.
>
> Sempre execute o comando `xfs_growfs` depois de executar o comando `lvextend`. Use a opção `-r` do comando `lvextend` para executar as duas etapas consecutivamente.

### Extensão de um sistema de arquivos EXT4 para o tamanho do volume lógico
```
# O comando resize2fs expande o sistema de arquivos para ocupar o novo LV estendido.
resize2fs /dev/vg01/lv01
```

>[!IMPORTANT]
> A principal diferença entre `xfs_growfs` e `resize2fs` é o argumento incluído para identificar o sistema de arquivos. O comando `xfs_growfs` usa o **ponto de montagem como um argumento**, e o comando `resize2fs` usa o **nome do LV como um argumento**. O comando xfs_growfs é compatível **apenas com um redimensionamento on-line**, enquanto o comando resize2fs é **compatível com o redimensionamento on-line e off-line**.

### Reduzir armazenamento do VG
A redução de um VG envolve a remoção de PVs não usados do VG. O comando pvmove move dados de extensões em um PV para extensões em outro PV com extensões livres suficientes no mesmo VG. Você pode continuar a usar o LV do mesmo VG durante a redução. Use a opção -A do comando pvmove para fazer backup automaticamente dos metadados do VG após uma alteração. Essa opção usa o comando vgcfgbackup para fazer backup de metadados automaticamente.

```
pvmove /dev/vdb3
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

>[!TIP]
> Use o comando `swapon --show` para exibir as prioridades do espaço de swap.
>
> As prioridades são definidas no arquivo de configuração `/etc/fstab`
>
> ```UUID=da98sd9ada7dadasd9-a8d98a9-d9890890        swap        swap    pri=<numero>          0       0```

