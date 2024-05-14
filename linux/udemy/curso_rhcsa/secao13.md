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
      ------------------+                                          Servidor 2
                        |
    🖥                  |
  Servidor 1            +-> 🔒 Chave Pública com extensão .pub         🖥 
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

>[!IMPORTANT]
> Copiar um arquivo sempre cria um inode de arquivo, e os atributos desse inode, incluindo o contexto SELinux, devem ser definidos inicialmente.
> 
> Mover um arquivo normalmente não cria um inode se a movimentação ocorrer **dentro do mesmo sistema de arquivos**, mas, em vez disso, move o nome do arquivo do inode existente para um novo local. Como os atributos do inode existente não precisam ser inicializados, um arquivo que é movido com `mv` preserva seu contexto SELinux, a menos que você defina um **novo contexto** no arquivo com a opção `-Z`.
> 
> Depois de copiar ou mover um arquivo, verifique se ele tem o contexto SELinux apropriado e defina-o corretamente se necessário.

>[!TIP]
> Para exibir uma lista de **todas as páginas do man do SELinux disponíveis**, instale o pacote e execute uma pesquisa de palavra-chave man -k para a string _selinux.
> ```
> dnf -y install selinux-policy-doc
> man -k _selinux
> ```

---

* **O SELinux tem muitas configurações e pode ficar complexo, porém para o exame iremos abordar apenas os tópicos pedidos, facilitando assim o domínio de atividades pedidas.**
* Nessa seção, vamos cobrir:
  - Definir modos o SELinux
  - Listar e identificar os contextos de processos e arquivos do SELinux
  - Restaurar contextos padrões do SELinux
  - Usar configurações de booleans (Ligado ou desligado) do SELinux
  - Diagnosticar e resolver mensagens de violações de politica do SELinux

* SELinux pode correr em 3 modos: **enforcing**, **permissive**, ou **disabled**
  - O modo de imposição(enforcing), o SELinux opera normalmente, reforçando a política de segurança carregada em todo o sistema
  - O modo permissivo, o sistema atua como se o SELinux estivesse impondo a política de segurança carregada, e registra o acesso nos logs, mas não nega nenhuma operação
  - O modo desativado é fortemente desencorajado; o sistema não apenas evita a aplicação da política SELinux, mas também evita rotular quaisquer objetos persistentes, como arquivos, tornando difícil habilitar o SELinux no futuro
* Usamos o comando `getenforce` para ver o modo atual do SELinux
* Usamos `setenforce` para mudar o modo do SELinux para enforcing ou permissivo. Essa mudança não sobrevive a um _reboot_ do sistema
* `setenforce 0` para modo permissivo `setenforce 1` para modo de imposição(_enforcing_)
* Use `setstatus` para ver informações do status do SELinux
* Para desabilitar ou mudar o modo SELinux, edite o arquivo `/etc/selinux/config`

>[!WARNING]
> A Red Hat recomenda reinicializar o servidor quando você alterar o modo SELinux de Permissive para Enforcing. Essa reinicialização garante que os serviços iniciados no modo permissivo sejam confinados no próximo boot.

>[!TIP]
> No exame se o SELinux estiver desabilitado pode ser necessário editar o arquivo `/etc/selinux/config` e dar reboot na máquina

```
# listar os rótulos de portas do SELinux 
semanage port -l
```

# Contextos de processos e arquivos

>[!TIP]
> Contexto de arquivos do SELinux
> ```
> SELinux user    Role         Type    Sensitivy Level   File
>       |          |             |            |           |
>  unconfined_u:object_r:httpd_sys_content_t:s0/var/www/html/file2
> ```

* Instale o pacotte `setroubleshoot-server`
* Definir contextos de arquivos e diretórios:
  - Use `man semanage-fcontext` para exemplos completos (busque "Example") **importante**
* Restaurar contextos de arquivo padrão
  - Use `restorecon` (de forma recursiva "-R") após usar os comandos do `semanage`, como descrito nos exemplos acima
* Use `ls -Z`para ver o contexto de diretórios e arquivos

# Configurações booleanas

* O SELinux usa booleans para tornar sua política mais flexível
* A política básica do SELinux é bastante rígida, mas atende à maioria dos requisitos
* Caso tenha necessidades para casos especiais, você pode ajustar a política do SELinux usando booleans
* Certifique que o `setroubleshoot-server` está instalado
* Use `man semanage-boolean` para exemplos
* Veja lista completa de booleans:
  - `getsebool -a `
* Filtra lista para ver homedirs do httpd:
  - `getsebool -a | grep homedirs`
* Veja a configuração atual e permanente do boolean:
  - `semanage boolean -l | grep homedirs`
* Mude configuração de forma permanente:
  - `setsebool -P <BOOLEAN> on/off`

>[!IMPORTANT]
> Lista booleans que não estão na configuração padrão (customizados)
> `semanage boolean -l -C`

# Diagnosticar e resolver violações a políticas de rotina do SELinux

>[!IMPORTANT]
>* **Problemas mais comuns no SELinux para o exame**:
>   - Um arquivo, diretório ou processo com o contexto de SELinux errado
>   - Configuração booleana precisa ser modificada
> * **Quando o SELinux nega uma ação, uma mensagem do Access Vector Cache (AVC) é registrada nos arquivos `/var/log/audit/audit.log` e `/var/log/messages` ou no `journald`**
> * **Verifique esses arquivos e busque por AVC se você suspeitar que o SELinux negou uma ação que você tentou executar**
 * Use `setenforce 0` para botar em modo permissivo para ver se o problema é relacionado ao SELinux
>[!TIP]
> * **Use o _journalctl_ para ver descrição do erro:**
>   - **`journalctl -t setroubleshoot --since="10 minutes ago"`**
 * Use a ferramenta _ausearch_ para ver mensagens de AVC:
   - `ausearch -m AVC -ts recent`
   - `-m` especifica o tipo de mensagem a ser retornada, e `-ts` significa timestanp, ou seja: retorne mensagens do tipo AVC que sejam recentes
 * Use _sealert_ para ler detalhes da mensagem de AVC:
   - `grep AVC /var/log/audit/audit.log`
   - `sealert -l [ID da mensagem retornada acima]`

>[!TIP]
> O Cockpit do RHEL inclui ferramentas para solucionar problemas do SELinux

