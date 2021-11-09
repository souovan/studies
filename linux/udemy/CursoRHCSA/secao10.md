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

## NMCLI

```bash
# Exibe todos dispositivos de rede
nmcli d s

# Exibe todas conexões de rede disponíveis
nmcli c s

# Verificar dados de uma conexão
nmcli c s <nome_da_conexao>

# Cria uma conexão de rede
nmcli c add con-name mycon type ethernet ifname enp1s0

# Configurar uma conexão
nmcli c m mycon +ipv4.dns 1.1.1.1 +ipv4.dns 1.0.0.1

# Levanta a conexão 
nmcli c up mycon
```

> Quando o paramêtro vier precedido de um símbolo + significa adição e é utilizado quando há mais de um valor a ser inserido
>
> ```bash
> # Configurar uma conexão
> nmcli c m mycon +ipv4.dns 1.1.1.1 +ipv4.dns 1.0.0.1
> ```

## NMTUI

* Interface de usuário de modo texto ( Text User Interface )
* Preferível para se usar no exame pois é mais simples de utilizar

