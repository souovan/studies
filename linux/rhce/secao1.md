# Lab configuration

* Create 6 VMS
  - 1 controlnode (ansible)
  - 5 nodes

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

