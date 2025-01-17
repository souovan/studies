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
# Check if the inventory is correct
ansible all --list-hosts
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

```bash
# Decrypt or encrypt a file with vault using a file as source of secret
ansible-vault decrypt vault.yml --vault-pass-file secret.txt

ansible-vault encrypt vault.yml --vault-pass-file secret.txt
```

# LVM Exercise Nodes preparation
```bash
# For LVM excercise
# Attach a 2Gb size disk on node4
# Attach a 1Gb size disk on node5
# Create a partition on node4
ssh node4 -- sudo parted /dev/vdb --script mklabel gpt mkpart primary 0% 100% set 1 lvm on

ssh node4 -- sudo partprobe /dev/vdb

ssh node4 -- sudo pvcreate /dev/vdb1

ssh node4 -- sudo vgcreate research /dev/vdb1

ssh node4 -- sudo vgs
# Create a partition on node4
ssh node5 -- sudo parted /dev/vdb --script mklabel gpt mkpart primary 0% 100% set 1 lvm on

ssh node5 -- sudo partprobe /dev/vdb

ssh node5 -- sudo pvcreate /dev/vdb1

ssh node5 -- sudo vgcreate research /dev/vdb1

ssh node5 -- sudo vgs
```

```bash
# Confirm selinux config
ansible all -a "cat /etc/selinux/config"
```