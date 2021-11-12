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

