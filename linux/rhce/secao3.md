# Commands for the EXAM

```bash
# Run playbook in dry run mode
ansible-playbook <playbook> --check
```

```bash
# Run playbook in dry run mode with ansible-navigator
ansible-navigator run <playbook> --check -m stdout
```

```bash
# Execute the playbooks
ansible-navigator run <playbook> -m stdout
```

```bash
# Change vault password
ansible-vault rekey secret.yaml
```

```bash
# Check if a configuration is correct
ansible all -a "<shell command>"
```

```bash
# Test the repository configuration
ansible all -a "yum repolist all"
```

```bash
# Install collections
ansible-galaxy collection install <collection> -p <directory_to_install_the_collection>
```

```bash
# Install a role from file
ansible-galaxy install -r <file.yaml> -p <directory_to_install_the_role>
```

```bash
# Create a new role
ansible-galaxy init <role_name>
```