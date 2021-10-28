# Camadas de gerenciamento de armazenamento

```
 ----------------------------------------------------------
|        Arquivos de sistemas, arquivos de swap            |
|__________________________________________________________|
        ^                         ^
        |                         |
        |    ------------------------------------
        |   |  Volumes Lógicos: Use a piscina de |
        |   |  um grupo de volume como partições |
        |   |____________________________________|
        |                         ^
        |                         |
 ----------------------   -------------------------------
| Partições: Tamanho   | | Grupo de Volume: Junta        |
| fixo de uma subseção | | diversos dispositivos de arma |
| de um dispositivo de | | zenamento para fazer uma      |
| armazenamento        | | piscina de armazenamento      |
|______________________| |_______________________________|
  ^      ^                                  ^          ^
  |      |                                  |          |
  |     ---------------------------------------------  |
  |    | Dispositivos de armazenamento: Disco rigido | |
  |    | HD externo, armazenamento em bloco          | |
  |    |_____________________________________________| |
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
* Use `fdisk <nomedodisco>` para criar uma partição em MBR
  - `fdisk /dev/sdb`
* Use `gdisk <nome do disco>` para criar uma partição em GPT
  - `gdisk /dev/sdc`
* Use `partprobe` para atualizar a tabela de partições do kernel

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

