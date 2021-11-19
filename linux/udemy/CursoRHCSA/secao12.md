# Fundamentos da firewall no RHEL8

* firewalld usa os conceitos de zonas e serviços, que simplificam o gerenciamento de tráfego.

* As zonas são conjuntos de regras predefinidas. As interfaces e fontes de rede podem ser atribuídas a uma zona

* Os serviços de firewall são regras predefinidas que cobrem todas as configurações necessárias para permitir o tráfego de entrada para um serviço específico e se aplicam a uma zona

* Firewall pode ser usado para separar redes em zonas diferentes de acordo com o nível de confiança que o usuário decidiu colocar nas interfaces e no tráfego dessa rede

* Uma **conexão só pode fazer parte de uma zona**, mas uma **zona pode ser usada para muitas conexões de rede**

  >  Lembre: Uma conexão é a configuração aplicada a uma interface de rede

* Use `man firewall.zones` para maiores informações sobre zonas da firewalld

* Use `firewall-cmd --get-zones`para ver lista de zonas pré-definidas

* As zonas prédefinidas são armazenadas no diretório e podem ser aplicadas instantaneamente a qualquer interface de rede disponível:

  * `/usr/lib/firewalld/zones/`

* Esses arquivos são copiados somente após serem modificados para o diretório

  * `/etc/firewalld/zones/`

## Serviços da firewalld

* Um serviço pode ser uma lista de portas locais, protocolos, portas de origem e destinos, bem como uma lista de módulos auxiliares de firewall carregados automaticamente se um serviço for habilitado

* A utilização de serviços economiza tempo do usuário, pois pode realizar diversas tarefas, como abrir portas, definir protocolos, habilitar o encaminhamento de pacotes e muito mais, em uma única etapa, em vez de configurar tudo um após o outro

* Use `firewall-cmd --get-services`para ver a lista de serviços pré-definidos

* Usamos a linha de comando com a ferramenta `firewall-cmd` da firewalld

* Como alternativa, você pode editar os arquivos XML no diretório:

  * `/etc/firewalld/services/`

* Se um serviço não for adicionado ou alterado pelo usuário, nenhum arquivo XML correspondente será encontrado em `/etc/firewalld/services/`

* Os arquivos podem ser usados como modelos se você quiser adicionar ou alterar um serviço no diretório:

  * `/usr/lib/firewalld/services/`

* A configuração de **tempo de execução** (runtime) **é a configuração ativa e não é permanente**

  Após recarregar / reiniciar o serviço firewalld ou uma reinicialização do sistema, as configurações de tempo de execução desapareceção. Exemplo:

  - `firewall-cmd --add-service=http`

* A configuração **permanente** é armazenada em arquivos de configuração e **se torna uma nova configuração de tempo de execução a cada inicialização da máquina ou quando recarregar / reiniciar o serviço firewalld**. Exemplo:

  - `firewall-cmd --permanent --add-service=http`
  - `firewall-cmd --reload`

* Use `firewall-cmd --runtime-to-permanent`para tornar a configuração de tempo permanente

> ```bash
> # Para verificar informações específicas de um serviço
> firewall-cmd --info-service=http
> ```

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

  

   
