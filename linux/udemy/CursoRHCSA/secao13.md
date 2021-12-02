# Conceitos de ACL - Access Control Lists

* Linux por padrão tem permissão de leitura(r), escrita(w) e execução(x), para usuários, grupos e outros. Não podemos dar acesso a mais de um usuário ou grupo a um arquivo ou diretório

* Problema: Como vamos dar acesso a um usuário ou grupo que não tem permissão de acesso definidas ?

  * Exemplo 1: O grupo vendas tem o diretório /amostra, ao qual apenas o grupo vendas tem acesso. Porém, precisamos dar acesso ao grupo RH a um arquivo sample_rh dentro do diretório /amostra/
  * Exemplo 2: Grupo de vendas quer dar acesso ao diretório /amostra/contas ao departamento de compatibilidade da empresa
  * Exemplo 3: Usuário tina quer dar acesso a usuário angie a um diretório dentro de seu diretório padrão, /home/tina/arquivos_angie/

* Solução: Lista de controle de acesso

* Temos 2 tipos de lista de controle de acesso:

* ACL Padrão:

  * Pode apenas ser aplicado a diretórios. Se um arquivo dentro do diretório não tiver uma ACL definida, esse arquivo usa a ACL padrão do diretório
  * Representamos uma ACL padrão com `-d` de default (padrão)
  * São opicionais
  * Note que arquivos existentes não herdam a ACL do diretório padrão, apenas arquivos novos

* ACL de acesso:

  * Lista de controle de acesso para um arquivo ou diretório

* Ver configuração atual de ACL:

  * `getfacl /amostra`

* Configurando uma ACL:

  * `setfacl [ opção ] [ especificação ] arquivo`
  * opção pode ser modificar `-m`, resetar `-b` ou remover `-x`
  * especificação seria o usuario ou grupo que estamos alterando a permissão na ACL
  * podemos usar `-d (padrão)` para um diretório
  * podemos usar `-R` para aplicar ACL de acesso de uma forma recursiva

# Conceitos de autenticação com base em chave

* Vantagens: não transferimos o password pela rede, protege contra ataques de força bruta, podemos desabilitar acesso por password e obrigar acesso por chave

```
Chave privada
     🔑    ---------------> 🔒 Chave Pública com extensão .pub         🖥 
      __________________                                           Servidor 2
                        |
    🖥                  |
  Servidor 1            --> 🔒 Chave Pública com extensão .pub         🖥 
                                                                   Servidor 3
```

## Configurar autenticação com base em chave para SSH

* Passos a serem feitos:
  - Gerar as chaves públicas e privadas
  - `ssh-keygen`
  * Instalar a chave pública no servidor
    - copiar usando o comando `ssh-copy-id` para o servidor
    - chaves são copiadas de forma automática para o diretório `/home/user/.ssh/authorized_keys`
* Autenticação de teste

# Visão geral do SELinux

* O SELinux - Security Enhanced Linux - Segurança melhorada do linux - prove uma camada adicional de segurança
* Criado pela NSA - National Security Agency (Agencia de Segurança Nacional) americana e desenvolvido pela Red Hat
* Vantagens
  - A Acão padrão é negar. Se uma regra de política SELinux não existir para permitir o acesso, como para um processo que abre um arquivo, o acesso é negado
  - O SELinux pode confirmar os usuários do Linux,
  - Maior sepração de dados e processos
  - O SELinux ajuda a mitigar os danos causados por erros de configuração
* Política de acesso padrão baseado em usuário, grupo e outras permissões são referidas como DAC - Discretionary Access Control - Controle de Acesso Discricionário - ou seja, usuárioa com permissões suficientes podem passar permissões para outros usuários
* O SELinux é implementado com MAC - Mandatory Access Control - Controle de Acesso Mandatório - ou seja, políticas de segurança a nível de sistema operacional da empresa
* O SELinux usa contextos - as vezes referidos com rótulos - como identificador que remove detalhes a nível de sistema e foca na segurança de uma entidade
* Por exemplo, processoss correndo servidor de web precisam ter um contexto de `httpd_t` para acessar arquivos no diretório `/var/www/html` e outros diretórios de web. Neste caso, `httpd_sys_content_t`
* Caso o servidor de web seja comprometido, acesso não sera permitido a outros arquivos devido ao contexto

---

* **O SELinux tem muitas configurações e pode ficar complexo, porém para o exame iremos abordar apenas os tópicos pedidos, facilitando assim o domínio de atividades pedidas.**
* Nessa seção, vamos cobrir:
  - Definir modos o SELinux
  - Listar e identificar os contextos de processos e arquivos do SELinux
  - Restaurar contextos padrões do SELinux
  - Usar configurações de booleans (Ligado ou desligado) do SELinux
  - Diagnosticar e resolver mensagens de violações de politica do SELinux

