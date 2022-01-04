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
| mais antigo com tamanho de partições mais limitado | evolução do _ext3_, permite capacidades maiores e verificação de sistemas de arquivos em caso de corrompimento com uso das `extends` | bastante utilizado em ambiente enterprise, possuí _journaling_ e é mais seguro e menos suscetível a corrupção dos dados |

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
