# Importante

>```bash
># Por segurança sempre usar esta forma de mudar para usuário root
>/bin/su -
>```

## Dicas

```bash
# Quando finalizando processos relacionados a de bancos de dados utilizar o kill *amigável* para evitar corrupção de dados
kill -15 [PID]
```

```bash
# Ferramenta de gerencimento e manipulação visual modo texto
cfdisk
```

>Caso for provisionar um sistema de arquivos que irá utilizar mais de 16Tb 
>
>Forçe para o tipo ser ext4 que habilita a opção 64bit conforme arquivo de configuração `less /etc/mke2fs.conf`.
> **Esta opção só ser configurada no momento de formatação da partição**

Uso de swap no SSD reduz a vida útil dele

```bash
# Parametro de ajuste do kernel que faz o sistema usar minimamente possivel o swap para preservar o SSD
echo 1 > /proc/sys/vm/sawppiness
```

## Comandos

```bash
# Altera atributos de arquivos e diretórios
chattr

# Lista atributos de arquivos e diretórios
lsattr
```

```bash
ls -lhaF

df -hT
```

## Notas

### BIOS

`BIOS inicialização` é a partição reconhecida pelo boot _legacy_

`Sistema EFI` No boot fica em `/boot/efi/` é uma partição do tipo _vfat_ (Windows) - único tipo de partição reconhecida pela bios *UEFI* - ela carrega sistemas de diagnóstico e kernel ou até o _grub_

### Sistemas de arquivos
 
| `ext3` | `ext4` | `xfs` |
| --- | --- | --- |
| mais antigo com tamanho de partições mais limitado | evolução do _ext3_, permite capacidades maiores e verificação de sistemas de arquivos em caso de corrompimento com uso das `extent` | bastante utilizado em ambiente enterprise, possuí _journaling_ e é mais seguro e menos suscetível a corrupção dos dados |

Quando for realizar migração a quente da partição `/usr` as pastas que podem ser removidas são:

* games/
* include/
* share/
* local/
* src/
* tmp/

***Caso seja removida alguma outra pasta o sistema será inutilizado**

### /etc/fstab

```bash
...
# options 
# noatime = não atualiza access time dos arquivos reduzindo a gravação do sistema de arquivos
# nodiratime = noatime mas para diretórios
# norelatime = não atualiza access time dos inodes importante usar se tiver noatime
# noexec = não permite execução de binários na partição montada
# nodev = não permite montagem de dispositivos na partição montada
/dev/sdaX   /particao    ext4    defaults,noatime,nodiratime,norelatime,noexec   0 0
...
```
### Blocos reservados

5% dos blocos são reservados para manutenção do sistema operacional pelo _root_

```bash
# Quantidade de blocos pode ser conferidas em sistemas ext2, ext3 e ext4 com o comando (Reserved block count)
dumpe2fs <dispositivo> | less
```

```bash
# % de blocos reservados pode ser diminuida com
tune2fs -m 1 <dispositivo>
```

### Discard e trimming

```bash
# Excluir inodes nao utilizados e libera espaço em dispositivos SSD
fstrim -va
```

### LVM (Linux Volume Manager)

> Tecnologia que permite realizar ajuste de particionamento sem precisar parar serviços ou sistema operacional

```
     +---------------+
     | volume fisico | tamanho nao pode ser alterado (particao do HD)
     +---------------+ 
            |
     +------------------+
     | grupo de volumes | uma particao fisica ou mais 
     +------------------+
            |
     +---------------+
     | volume logico | particao real
     +---------------+ 
```

Melhor criar partições pequena e ir aumentando conforme necessidade, pois pode ser necessário desmontar a partição e se for sistema ext4 quando reduzido perde a flag 64bit impedindo que posteriormente a partição seja extendida além do limite de 16Tb

# Troubleshoot de HARDWARE

```bash
# Para avaliar quais dispositivos de hardware estão utilizando os processadores
irqtop
```

# Administração de usuários e grupos

```bash
# Permite manipular permissão de usuários e grupos sem necessidade de root
gpasswd
```