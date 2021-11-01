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


