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

