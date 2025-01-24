# Tips and tricks

## looking for help and code snippets

```bash
man -k ansible
```

```bash
man ansible-config
```

```bash
# run the command and type / and type EXAMPLE to search for code snippets
# EXAMPLES
ansible-doc <ansible_module>
```

```bash
# When not available via ansible-doc
check the README inside the role path
```

## look all nodes to see if the configuration is right

```bash
ansible <inventory group or all> -a "<shell command>"
```

## to confirm the configuration before the exam starts

```bash
# after create the ansible.cfg file
ansible --version
```

```bash
# after create the inventory file
ansible-inventory --graph

ansible all -m ping
```

```bash
# check for the right collections installation
ansible-navigator collections
```

## to list ansible available modules

```bash
# list all available modules
ansible-doc --list
```

```bash
# filter for builtin modules
ansible-doc --list | grep builtin
#
ansible-doc --list | grep .posix
# 
ansible-doc --list | grep community.general.
```

```vim
" Enable vim to show a ($) sign in the end of line to show that it has no trilling spaces
set list
```
