# Commands for the EXAM

```bash
# Execute the playbooks
ansible-navigator run <playbook> -m stdout
```

```
# Change vault password
ansible-vault rekey secret.yaml
```

```
# Check if a configuration is correct
ansible all -a "<shell command>"
```
