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
check the README inside the role path
```

## look all nodes to see if the configuration is right

```bash
ansible <inventory group or all> -a "<shell command>"
```

## to confirm the configuration before the exam starts

```bash
ansible --version
```

```bash
ansible all -m ping
```