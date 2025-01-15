# Playbook examples for the exam

```yaml
# mount_iso.yml
- name: configure mount ISO
  hosts: all
  tasks:

    - name: mount the ISO dvd to /media
      ansible.posix.mount:
        path: /media
        src: /dev/sr0
        fstype: iso9660
        state: ephemeral
```

```yaml
# configure_yum.yml
- name: configure yum
  hosts: all
  tasks:
    
    - name: configure AppStream
      ansible.builtin.yum_repository:
        name: "Applications"
        description: "Apps"
        baseurl: file:///media/AppStream
        enabled: yes
        gpgcheck: 0
        # gpgcheck: http://content...

    - name: configure BaseOS
      ansible.builtin.yum_repository:
        name: "BaseOS"
        description: "operatingsystem"
        baseurl: file:///media/BaseOS
        enabled: yes
        gpgcheck: 0
        # gpgcheck: http://content...
```

```yaml
# requirements.yml
- src: https://github.com/bbatsche/Ansible-PHP-Site-Role.git
  name: phpinfo

- src: https://github.com/geerlingguy/ansible-role-haproxy.git
  name: balancer
```

```yaml
# apache role tasks/main.yml
---
# tasks file for apache
- name: install httpd and firewalld
  ansible.builtin.dnf:
    name: 
      - httpd
      - firewalld
    state: present

- name: start and enable firewalld
  ansible.builtin.service:
    name: firewalld
    state: started
    enabled: true

- name: host the web page using the template
  ansible.builtin.template:
    src: template.j2
    dest: /var/www/html/index.html

- name: allow the http traffic from the firewall
  ansible.posix.firewalld:
    service: http
    permanent: true
    state: enabled
    immediate: true

- name: start and enable httpd
  ansible.builtin.service:
    name: httpd
    state: started
    enabled: true
```

```yaml
# apache role templates/template.j2
My host is {{ ansible_fqdn }} {{ ansible_default_ipv4.address }}
```

```yaml
# apache_role.yml
- name: install and configure apache in dev group
  hosts: dev
  roles:
    - apache
```

```yaml
# roles.yml
- hosts: webservers
  roles:
    - phpinfo

- hosts: balancers
  roles:
    - balancer
```

```yaml
# webcontent.yml
- name: webcontent playbook
  hosts: dev
  tasks:
    
    - name: create directory devweb
      ansible.builtin.file:
        path: /devweb
        state: directory
        group: apache 
        mode: '02775' 
        setype: httpd_sys_content_t

    - name: create index.html file
      ansible.builtin.file:
        path: /devweb/index.html
        state: touch
        setype: httpd_sys_content_t

    - name: copy the content
      ansible.builtin.copy:
        content: "Development"
        dest: /devweb/index.html

    - name: Create a symbolic link
      ansible.builtin.file:
        src: /devweb 
        dest: /var/www/html/devweb 
        state: link

    - name: allow http traffic from the firewalld
      ansible.posix.firewalld:
        service: http
        permanent: true
        state: enabled
        immediate: true
```

```ini
# jinja2 hwreport.txt
HOSTNAME={{ ansible_hostname }}
MEMORY={{ ansible_memtotal_mb }}
BIOS={{ ansible_bios_version }}
CPU={{ ansible_processor }}
DISK_SIZE_VDA={{ ansible_devices.vda.size | default('NONE') }}
DISK_SIZE_VDB={{ ansible_devices.vdb.size | default('NONE') }}
```

```yaml
# hwreport.yml
- name: collect hardware report from all nodes
  hosts: all
  tasks:
   
   #- name: Download the file
   #  ansible.builtin.get_url:
   #    url: http://....
   #    dest: /root/hwreport.txt

    - name: generate report
      ansible.builtin.template:
        src: hwreport.txt
        dest: /root/hwreport.txt
```



