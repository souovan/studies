
```bash
                                                    /  "root"
    _____________________________________________________|_________________________________________________________
   |                  |                    |                         |                             |               | 
 /bin               /etc                 /sbin                     /usr                          /var              |
"essential user   "configuration files  "essential system   "read-only user application   "variable data files"    |_ /dev
command binares"  for the system"       binaries"           support data & binares"           |                    |  "device files
 bash               crontab              fdisk                |                               |                    |  include /dev/null"                 
 cat                cups                 fsck                 |_ /usr/bin                     |_ /var/cache        |
 chmod              fonts                getty                |  "most user commands"         |  "application      |_ /home
 cp                 fstab                halt                 |                               |   cache data"      |  "user home directories"
 date               host.conf            ifconfig             |_ /usr/include                 |                    |
 echo               hostname             init                 |  "standard include            |_ /var/lib          |_ /lib
 grep               hosts                mkfs                 |   files for 'C' code"         |  "data modified    |  "libraries & kernel modules"
 gunzip             hosts.allow          mkswap               |                               |   as programmes    |
 gzip               host.deny            reboot               |_ /usr/lib                     |   run"             |_ /mnt
 hostname           init                 route                |  "obj, bin, lib files for     |                    |  "mount files for temporary
 kill               init.d                                    |   coding & packages"          |_ /var/lock         |   filesystems"
 less               issue                                     |                               |  "lock files to    |
 ln                 machine-id                                |_ /usr/local                   |                    |_ /opt
 ls                 mtab                                      |  "local software"             |_ /var/log          |  "optional software applications"
 mkdir              mtools.conf                               |    /usr/local/bin             |  "log files"       |
 more               nanorc                                    |    /usr/local/lib             |                    |_ /proc
 mount              networks                                  |    /usr/local/man             |_ /var/spool        |  "process & kernel information
 mv                 passwd                                    |    /usr/local/sbin            |  "tasks waiting    |   files"
 nano               profile                                   |    /usr/local/share           |   to be processed" |
 open               protocols                                 |                               |  /var/spool/cron   |_ /root
 ping               resolv.conf                               |_ /usr/share                   |  /var/spool/cups      "home dir for the root user"
 ps                 rpc                                          "static date sharable        |  /var/spool/mail    
 pwd                securetty                                    accross all architectures"   | 
 rm                 services                                       /usr/share/man             |_ /var/tmp
 sh                 shells                                         "manual pages"                "temporary files saved
 su                 timezone                                                                      between reboots"
 tar
 touch
 umount
 uname

 ```
