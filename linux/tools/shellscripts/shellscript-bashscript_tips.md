# Bashscript

```sh
# Boa prática de hashbang, por que checa onde está o bash no sistema Linux onde o script está sendo executado

#!/usr/bin/env bash 

# Cria um novo arquivo vazio
> <nome_do_arquivo>

# Boa prática de adição de caminho (~/.local/bin) para armazenamento de scripts à variável de ambiente
# Inserir no arquivo ~/.bash_profile
PATH=$PATH:~/.local/bin

# Testa um script e exibe o codigo de retorno ( 0 o se script funcionou )
test -x <script> ; echo $?

# Em versoes mais novas do bash pode ser representado por 
[[ -x <script> ]] ; echo $?
```
