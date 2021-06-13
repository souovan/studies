# Linux relevant commands

```bash
# Description of the filesystem hierarchy
man 7 hier
```

# Tools 

# Utilities

```bash
# See installed package Date and Time on Debian or Ubuntu
zgrep " installed " /var/log/dpkg.log*
```

```bash
# Get distro RHEL/Fedora/CentOS version number
rpm -E %rhel
rpm -E %fedora
rpm -E %centos
```

```bash
# Display information about installed hardware on Linux
lsdev
hwinfo --short
lshw -short
```

# Troubleshoot

# Network

# Hacks

```
Save file on VIM without permission
:w !sudo tee %
```
