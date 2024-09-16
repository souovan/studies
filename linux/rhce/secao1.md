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
```

> [!NOTE] To make the ansible-navigator work is necessary to ssh from a terminal to the ansible VM

## .vimrc config to help in the exame

```bash
autocmd FileType yaml ai ts=2 sw=2 et cuc nu
```


