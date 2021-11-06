# Sistemas de arquivo ext4 e xfs

* Use `mkfs` para criar um arquivo de sistemas
  - `mkfs.fstype [-L label] dispositivo`
  - Use `mkfs.<tabtab>` para mostrar as opções de arquivos de sistemas
* Sempre adicione o arquivo de sistemas ao `/etc/fstab` para o exame
* Use os comandos `df -h` e `lsblk` para ver suas modificações
* Use `mount` e `umount` para montar e desmontar um arquivo de sistemas manualmente

# NFS - Network file system

* Protocolo permite distribuir arquivos entre computadores
* Para o exame é necessário configurar a máquina virtual para conectar a um servidor remoto NFS e montar os diretórios remotos na máquina local
* Usarmos `/etc/fstab` para montar os diretórios remotos na inicialização do servidor local
* Permissões de leitura e escrita são necessárias para uso dos diretórios remotos

* Para montar manualmente:
  - Use `showmount -e <servidor_remoto>` para ver os diretórios disponíveis para montagem no servidor NFS

```bash
# Monta o diretório remoto **dados** no servidor remoto **srv0.temweb.local** no diretório local **meunfs**
mount -t nfs srv0.temweb.local:/dados /meunfs
```

>```bash
># É necessário instalar o pacote nfs-utils para obter o comando showmount
>dnf install -y nfs-utils
>
># Comando auxíliar para checar os diretórios montados 
>df -h
>```

Atualize a entrada no arquivo `/etc/fstab`: 

```bash
srv0.temweb.local:/dados  /meunfs nfs _netdev 0 0
```

# Ampliar os volumes lógicos existentes

* Grupo de volume lógico pode ser extendido com `vgextend`
  - Certifique-se de preparar o dispositivo de bloco com `pvcreate`
* Para ampliar o volume lógico são 2 etapas:
  - Primeiro aumentamos o tamanho do volume lógico
  - Segundo expandimos o arquivo de sistemas para usar o novo espaço
* Podemos fazer a expansão do volume lógico e arquivo de sistemas com o comando:

```bash
# Parametro -l minúsculo é usado para indicar que será usado o tamanho em PEs ( Physical Extensions ) que podem ser conferidos com o comando `vgdisplay <grupo_de_volume_logico>`
lvresize -r -l +60 /dev/EXEMPLO/meulv1
```

> Arquivo de sistemas XFS pode apenas ser expandido, e não pode ser reduzido

* Para reduzir o volume lógico são 2 etapas: (ext3 e ext4)
  - Primeiro diminuímos o tamanho do arquivo de sistemas
  - Segundo diminuímos o volume lógico
* Podemos fazer a redução do arquivo de sistemas e do volume lógico com o comando:

```bash
# Parametro -L maiúsculo é usado para indicar que será usado o tamanho em Megas ou Gigas que também pode ser conferido com o comando `vgdisplay <grupo_de_volume_logico>` 
lvreduce -r -L -70M /dev/EXEMPLO/meulv3`
```

> Tanto no comando `lvresize` como no `lvreduce` o símbolo de `-` ou `+` indica que serão aumentados ou diminuídos o tamanho que segue o símbolo, **caso o símbolo seja omitido o comando alterará o tamanho total para o valor que segue o símbolo**

# SET-GID (definir ID do grupo)

* Quando configurado em diretórios, o SET-GID faz arquivos criados dentro do diretório assumirem o grupo dono do diretório
* Para o exame, você terá que configurar o SET-GID
* Isso permite diretórios serem criados para colaboração com vários usuários

# Permissões avançadas

| Nome | Valor numérico | Valor relativo | Em arquivos | Em diretórios |
| --- | --- | --- | --- | --- |
| stick bit | 1000 | +t | - | Usuário pode apagar arquivo apenas se ele for o dono do arquivo ou diretório |
| SUID - Set user ID | 4000 | u+s | Executa arquivos com permissões do dono do arquivo | - |
| GUID - Set Group ID | 2000 | g+s | Executa arquivo com permissões do grupo dono do arquivo | Arquivos criados no diretório tem o dono do grupo do arquivo |

## Principais comandos para SET-GID

```bash
# Para adicionar um grupo
groupadd

# Adicionar usuários
useradd

# Mudar o dono de diretório (ou arquivos)
chown

# Mudar as permissões do diretório
chmod
```

>```bash
># Ao utilizar os comandos chown ou chmod podem ser utilizados os parametrôs especiais nobody(usuário especial) ou nogroup (grupo especial) que servem para que o diretório ou arquivo não tenha dono ou grupo dono
>#Exemplos:
>chown nobody:gerentes /home/gerentes/
>chown gerente:nogroup /home/gerentes/
>```

# Configurar compactação de disco

* Virtual Data Optimization - VDO (optimização de dados virtuais)
* Troca entre recursos de CPU e RAM por espaço em disco
* Comprime e faz deduplicação de arquivos
  - Deduplicação: Elimina dados duplicados ou redundanetes
* Pode economizar até 10:1 para KVM hypervisor usando máquinas virtuais - 1GB aparece como 10GB
* Vamos usar 3:1 para arquivos - 1GB aparece como 3GB de espaço
  - Exemplo: um disco de 10GB mostrará 30GB de espaço disponível
* Minímo de 10GB para teste

```                                 
                                    _____________________   _____________________
                                   |                     | |                     |
                                   | Arquivo de Sistemas | | Arquivo de Sistemas |
                                   |_____________________| |_____________________|
                                    _____________________   _____________________
                                   |                     | |                     |
                                   |    Volume lógico    | |    Volume lógico    |
                                   |_____________________| |_____________________|
 ________________________________   _____________________________________________
|                                | |                                             |
| Arquivo de Sistemas: xfs, ext4 | |            Grupo de Volume Lógico           |
|________________________________| |_____________________________________________|
 ________________________________   _____________________________________________
|                                | |                                             |
|              VDO               | |                     VDO                     |
|________________________________| |_____________________________________________|
 ________________________________   _____________________________________________
|                                | |                                             |
|     Dispositivo de bloco       | |            Dispositivo de Bloco             |
|________________________________| |_____________________________________________|
```

## Passos para configuração da compactação de disco (VDO)

```bash
dnf install -y vdo kmod-kvdo

systemctl start vdo && systemctl enable vdo

# Criamos o dispositivo chamado "meuvdo" com 30GB de espaço lógico no disco de 10GB /dev/sdd
# writePolicy é a forma de escrever em disco, recomendado usar auto
vdo create --name=meuvdo --device=/dev/sdd --vdoLogicalSize=30G --writePolicy=auto

# Prepare para LVM e formatecom um arquivo de sistemas
mkfs.xfs -K /dev/DISCOVDO/meuvdo1

# Edite o /etc/fstab
/dev/DISCOVDO/meuvdo1 /mnt  xfs defaults,_netdev,x-systemd.requires=vdo.service 0 0
```

# Gerenciar armazenamento em camadas

* Usamos o `stratisd` como gerenciamento de armazenamento em camadas

* O `stratisd`é um arquivo de sistemas gerenciador de volumes

* Conceito principal: Criamos uma piscina a partir dos dispositivos de bloco, e a partir dessa piscina de discos ou partições criamos volumes

* Usa XFS como padrão

* Recomendado usar UUID quando configurar montagem automática no `/etc/fstab`

  > ```bash
  > # Exemplo de configuração /etc/fstab (note que é preciso adicionar defaults,x-systemd.requires=stratisd.service)
  > UUID=<id>	/camadas/fs1	xfs	defaults,x-systemd.requires=stratisd.service	0 0
  > 
  > # Após adicionar entrada do stratis no arquivo /etc/fstab utilizar
  > systemctl daemon-reload
  > ```

* Os sistemas de arquivos são provisionados de forma thin (virtual) e não tem um tamanho total fixo

* O tamanho real de um sistema de arquivos aumenta com os dados armazenados nele. Se o tamanho dos dados se aproxima do tamanho virtual do sistema de arquivos, Stratis aumenta o volume e o sistema de arquivos automáticamente

```bash
# Mostra o espaço real usado por um sistema de arquivos
stratis filesystem list
```

* Componentes:
  * **filesystem**: Cada pool contém diversos arquivos de sistemas
  * **pool**: Conjunto de blockdevs
  * **blockdev**: Dispositivos de bloco e partições

```
 ____________________   ____________________   ____________________
| filesystem(arquivo | | filesystem(arquivo | | filesystem(arquivo | 
|  de sistemas XFS)  | | de sistemas XFS)   | | de sistemas XFS)   |
|____________________| |____________________| |____________________|
 __________________________________________________________________
|                  Pool (piscina de blockdevs)                     |
|__________________________________________________________________|
 ___________________   _____________________   ____________________
|    blockdev       | |      blockdev       | |     blockdev       |
|___________________| |_____________________| |____________________|
```

```bash
# Para instalar o stratis
dnf install -y stratisd stratiscli

# Habilitar o stratis
systemctl enable stratisd

# Iniciar o stratis
systemctl start stratisd
```

* Podemos fazer um backup de um *stratis filesytem* com snapshots
  - Primeiro criamos o snapshot, e depois podemos facilmente restaurar um arquivo de sistemas stratis
* Poremos remover um arquivo de sistemas e removê-lo da pool:
  - Desmontamos o arquivo de sistemas
  - Removemos o arquivo de sistemas
* Podemos remover uma pool do stratis
  - Removemos todos os arquivos de sistemas stratis
  - Removemos a pool

> ```bash
> # Consultar a utilização do stratis
> stratis -h 
> # ou
> stratis <comando> -h
> ```


