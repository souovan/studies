# Fundamentos de configuração de rede

* **Internet Protocol** - IP: Todos os dispositivos conectados a uma rede tem um IP. Para facilitar comunicação, cada IP percente a uma rede. Para comunicar com um dispositivo em uma outra rede, um roteador é usado.
* IPv4: Endereços de IP em 32 bits, por exemplo:
  * 192.168.1.10
* IPv6: Endereços de IP em 128 bits, representando de forma hexadecimal: 0-9 e a-f. Endereço escrito em 8 hexadecimal partes com 16 bits cada:
  * fe80::fc54:ff:fe5b:5b38
* **Netword mask**: Para saber qual rede cada dispositivo pertence, usamos uma subnet mask
  * Forma classica: 255.255.255.0
  * Forma CIDR: 24
  * Acima, forma clássica representa a mesma rede da forma CIDR
* **Servidores DNS**: O livro de telefone da internet. Ao invés de memorizar o IP, memorizamos o nome. O serviços DNS a partir do nome de domínio, acha o IP do dispositivo e conecta com o endereço de IP ao dispositivo
  * Exemplo: www.google.com
* **Default Gateway**: Endereço do roteador, ou dispositivo que conecta a redes extrenas ao qual o dispositivo se encontra
* **Portas**: Enquanto o IP identifica o dispositivo, portas identifica o serviço ao qual devem ser conectados. Por exemplo, porta 80 se comunica com um servidor de web, enquanto porta 22 comunica com o protocolo ssh.
* Usamos configuração estática ou dinâmica
  * **Estática**: Escolhemos configuração manual, e inserimos dados necessários: IP, Network Mask, Default Gateway, Servidores de DNS
  * **Dinâmica**: Apontamos para servidores de DHCP, e este prove todos os dados necessários para configuração necessário e adicionamos DNS
* Podemos usar as ferramentas de rede do RHEL para configurar IPv4 e IPv6:
  * `nmtui` - Network Manager Text User Inferface
  * `nmcli` - Network Manager Command Line Interface

## NetworkManager

O serviço NetworkManager monitora e gerencia as configurações de rede de um sistema.
É possível interagir com o serviço NetworkManager pela linha de comando ou com ferramentas gráficas. Os arquivos de configuração do serviço são armazenados no diretório /etc/NetworkManager/system-connections/.

>[!IMPORTANT]
> A partir do Red Hat Enterprise Linux 8, os arquivos de configuração de formato ifcfg e o diretório /etc/sysconfig/network-scripts/ estão obsoletos. O NetworkManager agora usa um formato de arquivo de chave no estilo INI, que é uma estrutura de par de chave-valor para organizar propriedades. O NetworkManager armazena perfis de rede no diretório /etc/NetworkManager/system-connections/. Para compatibilidade com versões anteriores, as conexões de formato ifcfg no diretório /etc/sysconfig/network-scripts/ ainda são reconhecidas e carregadas.

As conexões de serviço do NetworkManager têm dois tipos de configuração. Propriedades de conexão estáticas são configuradas pelo administrador e armazenadas nos arquivos de configuração /etc/NetworkManager/system-connections/*.nmconnection. As propriedades de conexão dinâmica são solicitadas de um servidor DHCP e não são armazenadas de modo persistente.

## NMCLI

>[!TIP]
> Você pode abreviar objetos e ações nmcli. Por exemplo, você pode abreviar `nmcli device disconnect` como `nmcli dev dis` e `nmcli connection modify` como `nmcli con mod`. A abreviação pode ser tão curta quanto uma única letra, mas deve usar caracteres suficientes para identificar exclusivamente o objeto a ser gerenciado.

```bash
# Exibe todos dispositivos de rede
nmcli d s

# Exibe todas conexões de rede disponíveis
nmcli c s

# Verificar as configurações de uma conexão
nmcli c s <nome_da_conexao>

# Cria uma conexão de rede
nmcli c add con-name mycon type ethernet ifname enp1s0

# Configurar uma conexão
nmcli c m mycon +ipv4.dns 1.1.1.1 +ipv4.dns 1.0.0.1

# Levanta a conexão 
nmcli c up mycon
```

>[!TIP]
> Quando o paramêtro vier precedido de um símbolo + significa adição e é utilizado quando há mais de um valor a ser inserido
>
> ```bash
> # Configurar uma conexão
> nmcli c m mycon +ipv4.dns 1.1.1.1 +ipv4.dns 1.0.0.1
> ```

Embora a maneira recomendada de gerenciar perfis seja com o comando `nmcli` é possivel modificar os perfis de rede editando o arquivo de configuração da conexão em */etc/NetworkManager/system-connections/*. Embora os comandos nmcli se comuniquem diretamente com o NetworkManager para implementar modificações imediatamente, as edições do arquivo de conexão não são implementadas até que o NetworkManager seja solicitado a recarregar o arquivo de configuração. Com a edição manual, você pode criar configurações complexas em etapas e carregar a configuração final quando estiver pronta.

```
# Use para recarregar todos perfis de conexão
nmcli con reload
```

## NMTUI

* Interface de usuário de modo texto ( Text User Interface )
* Preferível para se usar no exame pois é mais simples de utilizar

# Configurar endereços IPv6

* Todas as conexões configuradas podem ser editadas diretamente no diretório:
  * `/etc/sysconfig/network-scripts`
* Note que arquivos tem prefiso de ifcfg- por padrão
* Endereços de IPv6 não é recomendado configuração manual por ser prone a erros
* Essencial:
  * IPV6INIT="yes" Inicializa a interface para endereçamento IPv6
  * IPV6_AUTOCONF="yes" Ativa a configuração automática de IPv6 para a interface
* Outros:
  * IPV6_DEFROUTE="yes" Indica que a rota IPv6 padrão foi atribuida à interface
  * IPV6_FAILURE_FATAL="no" Indica que o sistema não falhará mesmo quando o IPv6 falhar
* Use o comando `ip` para ver a configuração de rede em sua máquina virtual:
  * `man ip` (Veja exemplos no fim da página do manual)
  * `ip addr`(Mostra endereços de IP de todas as interfaces)
  * `ip route`(Mostra a tabela de rotas)
* Use **nmcli** ou **nmtui** para ver configurações de IPv6

# Configurar resolução de nome do host

* Podemos fazer de 2 formas:
  * Apontar para um servidor de DNS
  * Configurar o arquivo `/etc/hosts`
* Para o exame, provável ter que apontar para um servidor DNS conforme instruções
* Para o curso, editamos o arquivo `/etc/hosts`
* Veja os servidores de DNS ativos no arquivo:
  * `cat /etc/resolv.conf`
  * Use `systemctl restart NetworkManager` caso tenha feito alguma alteração

>[!TIP]
> Também pode ser alterado editando o arquivo em `/etc/sysconfig/network-scripts/ifcfg-<nome_do_adaptador>`

## Teste de resolução de nomes DNS

```
host <fqdn.hostname ou IP>
```

```
dig <fqdn.hostname>
```

Os comandos host e dig não exibem a configuração no arquivo */etc/hosts*. Para testar o arquivo */etc/hosts*, use o comando `getent hosts <fqdn.hostname>`.


# Restrigir acesso à rede usando firewall-cmd

>[!TIP]
> Nomes de portas padrão bem conhecidos são listados no arquivo `/etc/services`.

* Firewall usa portas para filtrar(bloquear) acesso externo a um serviço
* Para pacotes da network terem acesso a um serviço, a porta precisa estar aberta
* Todas as portas são fechadas por padrão, então usamos a firewall para abrir as portas de acordo
* Podemos abrir portas:
  - Com serviços pré-definidos
  - Diretamente uma porta específica
* Temos uma seção específica dedicada a Firewalld

```bash
# Exibe informações sobre quais serviços estão habilitados para a zona ativa do firewall
firewall-cmd --list-all

# Para verificar a lista completa
firewall-cmd --get-services

# Adiciona um serviço em tempo de execução (runtime) não é persistente após reboot
firewall-cmd --add-service=https

# Adicionar permanentemente e persiste ao reboot 
firewall-cmd --permanent --add-service=https
# (não entra no runtime sendo preciso recarregar o firewall)
firewall-cmd --reload
```
