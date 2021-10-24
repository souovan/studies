# Camadas de gerenciamento de armazenament

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


