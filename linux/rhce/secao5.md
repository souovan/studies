# Playbook examples for the exam

```yaml
# playbook mount_iso.yml
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
# playbook configure_yum.yml
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
# roles requirements.yml
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
# playbook webcontent.yml
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
# jinja2 file hwreport.txt
HOSTNAME={{ ansible_hostname }}
MEMORY={{ ansible_memtotal_mb }}
BIOS={{ ansible_bios_version }}
CPU={{ ansible_processor }}
DISK_SIZE_VDA={{ ansible_devices.vda.size | default('NONE') }}
DISK_SIZE_VDB={{ ansible_devices.vdb.size | default('NONE') }}
```

```yaml
# playbook hwreport.yml
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

```yaml
# playbook issue.yml
- name: configure the /etc/issue
  hosts: all
  tasks:
   
    - name: configure /etc/issue dev
      ansible.builtin.copy:
        content: "Development"
        dest: /etc/issue
      when: inventory_hostname in groups['dev']

    - name: configure /etc/issue test
      ansible.builtin.copy:
        content: "Test"
        dest: /etc/issue
      when: inventory_hostname in groups['test']

    - name: configure /etc/issue prod
      ansible.builtin.copy:
        content: "Production"
        dest: /etc/issue
      when: inventory_hostname in groups['prod']
```

```yaml
# playbook hosts.yml
- name: collect hosts connection info and updates /etc/hosts
  hosts: all
  tasks:

    - name: copy the template to the host file 
      ansible.builtin.template:
        src: myhosts.j2
        dest: /etc/myhosts
      when: inventory_hostname in groups['dev']
```

```ini
# jinja2 file myhosts.j2
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
::1       localhost localhost.localdomain localhost6 localhost6.localdomain6
{% for x in groups['all'] %}
{{ hostvars[x].ansible_default_ipv4.address }} {{ hostvars[x].ansible_fqdn }} {{ hostvars[x].ansible_hostname }}
{% endfor %}
```

Check [LVM Exercise Nodes preparation](secao3.md#lvm-exercise-nodes-preparation)

```yaml
# playbook lvm.yml
- name: lvm playbook
  hosts: all
  tasks:
   
    - block:
        - block:
            - name: create lv of 1500m
              community.general.lvol:
                vg: research
                lv: data
                size: 1500m
              when: ansible_lvm.vgs.research.size_g == "2.00"
        - block:
            - name: display message vg size is insufficient
              debug:
                msg: "INSUFFICIENT SIZE OF VG"
              when: ansible_lvm.vgs.research.size_g == "1.00"
            - name: create lv of 800M
              community.general.lvol:
                vg: research
                lv: data
                size: 800m
              when: ansible_lvm.vgs.research.size_g == "1.00"
      when: ansible_lvm.vgs.research is defined

   #- name: debugging
   #  debug:
   #    msg: "{{ ansible_facts['ansible_lvm']['vgs'] }}"
   #  when: ansible_lvm.vgs.research is defined

    - name: format the lv with ext4 filesystem
      ansible.builtin.filesystem:
        fstype: ext4
        dev: /dev/research/data
      when: ansible_lvm.vgs.research is defined

    - name: display message device not found
      debug:
        msg: "VG NOT FOUND"
      when: ansible_lvm.vgs.research is not defined
```

