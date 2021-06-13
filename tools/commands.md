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
```bash
# Compress and transfer a .tar.gz file securely over SSH when ther is no disk space on client
tar xzcf - whatever/ | ssh user@host 'cat > whatever.tar.gz'
```

```bash
crontab -e #Edit configuration file
#Minutes Hour Month_day Month Weekday Command
# 0-59   0-23    1-31   1-12    0-7   bash.sh

contrab -l #List rules

#Important directories 
#/etc/cron.<TAB> 
#vim /etc/crontab
#vim /etc/cron.allow #Insert username to allow who can do cronconfigs
#vim /etc/cron.deny  #Insert username to deny who can do cronconfigs
```

```bash
#Show common linux defined ports
less /etc/services
```

# Troubleshoot

```bash
# Show kernel informations on boot
dmesg
```

```bash
# Inode disk space human readeble
df -ih
```

```bash
# Show open network connections by programs 
netstat -atunp
```

```bash
# Show processes
ps -ef
```

```bash
# Show processes real-time
top
```

```bash
# A better top
htop
```
[htop explained](../images/htop_explained.jpeg)

```bash
# Show installed packages via RPM
rpm -qa
```

```bash
#System commands/processes troubleshoot tool
strace -o output -f command

strace -fp #trace by PID 

strace -c #List syscalls
```

# Network

```bash
# Show network connections IPs by adapter in color
ip -br -c a
```

# Hacks

```
Save file on VIM without permission
:w !sudo tee %
```
