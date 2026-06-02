# Lab configuration

* Create 6 VMS
  - 1 controlnode (ansible)
  - 5 nodes

## Pre requisitos

Este lab usa Vagrant com o provider `libvirt`, conforme definido no
`makefile` por `VAGRANT_DEFAULT_PROVIDER=libvirt vagrant`.

Antes de executar `make start-vms`, confirme os pontos abaixo:

- Vagrant instalado.
- Libvirt instalado e em execucao.
- Plugin `vagrant-libvirt` instalado.
- Usuario com permissao para acessar o libvirt.
- Rede libvirt `default` definida e ativa.

Para validar a rede `default`:

```bash
virsh net-list --all
```

Se a rede `default` nao existir, defina, inicie e habilite o autostart:

```bash
virsh net-define /usr/share/libvirt/networks/default.xml
virsh net-start default
virsh net-autostart default
```

Caso os comandos acima sejam executados contra o libvirt do sistema e exijam
privilegios administrativos, use `sudo`:

```bash
sudo virsh net-define /usr/share/libvirt/networks/default.xml
sudo virsh net-start default
sudo virsh net-autostart default
```

Sem a rede `default`, o `make start-vms` pode falhar durante o boot das VMs com
erro semelhante a:

```text
Call to virDomainCreate failed: Network not found: no network with matching name 'default'
```

Com os pre requisitos atendidos, inicie o lab:

```bash
make start-vms
```

## Pre requisites configuration for the EXAM

```bash
# Install ansible on ansible node
dnf install -y ansible-core
```

```bash
# Install ansible-navigator on ansible node
pip install ansible-navigator
# or
sudo python3-pip install ansible-navigator
```

```bash
# Install the ansible rhel-system-roles
sudo dnf install -y rhel-system-roles
```

> [!NOTE]
> To make the ansible-navigator work is necessary to ssh from a terminal to the ansible VM


```bash
# Configuration to meet the requirements for exam lab
cd /home/van/ansible/roles/

git clone https://github.com/bbatsche/Ansible-Nginx-Passenger-Role.git

mv Ansible-Nginx-Passenger-Role bbatsche.Nginx
```

## .vimrc config to help in the exame

```bash
autocmd FileType yaml setlocal ai ts=2 sw=2 et cuc nu
```

```bash
# Generates an ansible.cfg example file
ansible-config init --disabled -t all > ansible.cfg
```
