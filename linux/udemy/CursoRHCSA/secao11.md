# Criar, excluir e modificar contas de usuário locais

* Linux existem 2 tipos de contas: contas para **usuário** e contas para **serviços**
* Contas de usuários geralmente são configuradas com password para autenticação
* Contas de serviços e usuários são mantidas nos arquivos:
  * `/etc/passwd`: Diferentes propriedades da conta são definidos
  * `/etc/shadow`: Onde propriedades do passwd de cada conta é configurado. Apenas usuário root (e processos correndo como usuário root) tem acesso

```
 Propriedades de uma conta de usuário linux no arquivo /etc/passwd
 
 ______________________________________________________________________________
|            russell:x:1000:1000:russell:/home/russel:/bin/bash                |
|______________________________________________________________________________|
| Nome | Password | User ID | Grupo ID | Comentário | Diretório padrão | Shell |
|______|__________|_________|__________|____________|__________________|_______|
```

```bash
# Adicionar usuário
useradd
# useradd -u 2000 -G gerente, marketing joana

# Remover usuários
userdel -r joana # Remove usuária joana e dirtório padrão (opção -r)

# Modifica propriedades de usuários existentes
usermod -aG diretores joana

# Mostra informações da conta de usuário
id joana
```
> ```bash
> # Adiciona um usuário sem acesso a uma shell (não consegue logar)
> useradd -s /sbin/nologin bob
> ```

# Alterar senhas e ajustar tempo de senha para contas de usuário locais

* Use comando `passwd` para definir password de usuário
  - `passwd joana`
  - Use o comando `passwd` como usuário _root_
* Use o comando `chage` (change age - mudar idade) para configurar propriedades do password (como root)
  - Use `man chage` para ver exemplo de expiração de conta:
    - `chage -E $(date -d +180days +%Y-%m-%d)`
* Use `chage -l joana` para ver info sobre password do usuário joana
* Use `chage joana` para entrar em um menu e preecher as opções

# Criar, excluir, e modificar grupos locais e membros de grupos

* Usuários pertencem a 2 tipos de grupos:
  - Grupo primário:
    - Cada usuário precisa ter um grupo primário, e existe apenas um grupo primário
    - Quando usuário cria arquivos, o arquivo é parte do grupo primário do usuário
  - Grupos secundários:
    - Importante para configurar acesso a arquivos
    - Se o usuário fizer parte do grupo secundário, e o grupo secundário tiver permissões de acesso a arquivos, o usuário poderá acessar os arquivos.

## Propriedades do /etc/group

* Use `groupadd` para adicionar um grupo
* Use `groupmod` para modificar nome e ID do grupo
* Use `groupdel` para remover um grupo
* Informações de grupos do sistema são armazenados no arquivo `/etc/group`

```
 ..........................................................................................
|                                                                                          |
|                         desenvolvedores:x:2001:russell                                   |
|__________________________________________________________________________________________|
|                |                                        |          |                     |
|  Nome do grupo |  Password do grupo (não é muito usado) | Group ID | Usuário como parte  |
|                |                                        |          | do grupo secundário |
|________________|________________________________________|__________|_____________________|
```

