---
ignore_macros: true
---
# Manage Cleura Cloud resources with Ansible

In this tutorial, you will use Ansible to create a keypair, a network
and a server in {{brand}}. You will make sure the server is up to date,
automatically reboot it if necessary, and then install, enable, and
activate a Systemd service on it. Finally, you will again use Ansible to
delete the server, the network, and the keypair.

## Prerequisites

Assuming you already have an [account in
{{brand}}](/howto/getting-started/create-account), go ahead and enable
the [OpenStack CLI](/howto/getting-started/enable-openstack-cli). Then,
make sure Ansible is [installed on your
computer](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

Although it is not required, some familiarity with [YAML
syntax](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html#yaml-syntax)
helps.

Finally, for your convenience, use your terminal application to create a
working directory and change into it:

```bash
mkdir ~/ansible_workbench && cd ~/ansible_workbench
```

From now on, you will be working inside that directory exclusively.

## Create a keypair

First, create a new local keypair:

```bash
ssh-keygen -q -t ed25519 -C 'my_ansible_key' -P '' -f ansible_key
```

You will get a file named `ansible_key`, which has a private key, along
with a file named `ansible_key.pub`, which has the corresponding public
key.

Next up, use your favorite text editor to create a YAML file named
`keypair.yml` with the below content:

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Upload local public key to remote
      openstack.cloud.keypair:
        state: present
        name: ansible_key
        public_key_file: ansible_key.pub
```

You just created an Ansible *playbook* (file `keypair.yml`) with a
single *play* (begins at `hosts: localhost`), which contains a single
*task* (begins at `name: Upload local public key to remote`).

Go ahead and ask Ansible to run the playbook:

```bash
ansible-playbook keypair.yml
```

The output on your terminal will look like this:

```plain
PLAY [localhost] ****************************************************************************************************************************

TASK [Upload local public key to remote] ****************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0    
```

Below the `PLAY RECAP` line, notice that it says `changed=1`. That is
because exactly one keypair has just been created. Optionally, verify
using the `openstack` client:

```bash
openstack keypair list
```

```plain
+-------------+-------------------------------------------------+------+
| Name        | Fingerprint                                     | Type |
+-------------+-------------------------------------------------+------+
| ansible_key | 30:2e:b8:c1:a8:5a:fd:b2:5b:6e:6d:6c:b0:b7:fd:f6 | ssh  |
+-------------+-------------------------------------------------+------+
```

Try running the same playbook again:

```bash
ansible-playbook keypair.yml
```

```plain
PLAY [localhost] ****************************************************************************************************************************

TASK [Upload local public key to remote] ****************************************************************************************************
ok: [localhost]

PLAY RECAP **********************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Even though the key named `ansible_key` was created during the first run
of the playbook, running the same playbook once more produced no warning
or error. Notice the information below the `PLAY RECAP` line, though,
which now says `changed=0`. Ansible was smart enough to detect that the
keypair was already there, so it did not try to create it again.

## Put together a feature-rich network

Using your text editor of choice, create a new playbook named
`networking.yml` with the below content:

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Create network
      openstack.cloud.network:
        state: present
        name: ansible_net

    - name: Create subnet
      openstack.cloud.subnet:
        state: present
        network_name: ansible_net
        name: ansible_subnet
        cidr: 10.254.254.0/24
        gateway_ip: 10.254.254.254
        dns_nameservers:
          - 8.8.8.8
          - 9.9.9.9

    - name: Create router
      openstack.cloud.router:
        state: present
        name: ansible_router
        network: ext-net
        interfaces:
          - net: ansible_net
            subnet: ansible_subnet
            portip: 10.254.254.254
```

This playbook is way longer compared to `keypair.yml`. That's because
its only play now contains three tasks, each for creating a network, a
subnet, and a router. Tell Ansible to run the playbook:

```bash
ansible-playbook networking.yml 
```

```plain
PLAY [localhost] ****************************************************************************************************************************

TASK [Create network] ***********************************************************************************************************************
changed: [localhost]

TASK [Create subnet] ************************************************************************************************************************
changed: [localhost]

TASK [Create router] ************************************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************
localhost                  : ok=3    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Below line `PLAY RECAP` this time says `changed=3`, for three new
objects have just been created. Use the `openstack` client to verify:

```bash
openstack network list -c ID -c Name
```

```plain
+--------------------------------------+--------------+
| ID                                   | Name         |
+--------------------------------------+--------------+
| 0999bc75-59a6-424e-aa3d-2098d1696886 | ansible_net  |
| 2aec7a99-3783-4e2a-bd2b-bbe4fef97d1c | ext-net      |
| 6c340d2b-e2cf-478a-9074-37e6770decf8 | network_fra1 |
+--------------------------------------+--------------+
```

```bash
openstack subnet list -c ID -c Name -c Subnet
```

```plain
+--------------------------------------+----------------+-----------------+
| ID                                   | Name           | Subnet          |
+--------------------------------------+----------------+-----------------+
| 3bea90d8-474d-421a-ad4d-0fc43b1f7ebe | ansible_subnet | 10.254.254.0/24 |
| df6fb6ca-4751-4b74-8b3e-5fbda0117cea | subnet_fra1    | 10.15.25.0/24   |
+--------------------------------------+----------------+-----------------+
```

```bash
openstack router list -c ID -c Name -c Status -c State
```

```plain
+--------------------------------------+----------------+--------+-------+
| ID                                   | Name           | Status | State |
+--------------------------------------+----------------+--------+-------+
| 62f885d8-6b13-4161-89d1-003c4fafec55 | router_fra1    | ACTIVE | UP    |
| e8c043ae-3610-419a-843f-2ccb3cc95464 | ansible_router | ACTIVE | UP    |
+--------------------------------------+----------------+--------+-------+
```

## Spin-up a server

Up to this point, you have set up proper networking over at {{brand}},
and you also have a convenient keypair up there. It's time you spun-up a
cloud server. Open your text editor and create playbook `server.yml`
with the following content:

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Create server
      openstack.cloud.server:
        state: present
        name: precarious_puffin
        image: 'Ubuntu 22.04.1 Jammy Jellyfish 230124'
        flavor: b.2c4gb
        volume_size: 48
        boot_from_volume: true
        key_name: ansible_key
        network: ansible_net
        auto_ip: true
        security_groups: default
```

Run the playbook to instantiate the server:

```bash
ansible-playbook server.yml
```

```plain
LAY [localhost] ****************************************************************************************************************************

TASK [Create server] ************************************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

The new server has just been created. Use the `openstack` client to
verify:

```bash
openstack server list -c Name -c Status
```

```plain
+-------------------+--------+
| Name              | Status |
+-------------------+--------+
| precarious_puffin | ACTIVE |
+-------------------+--------+
```

Optionally, jot down the server's public IP address with `openstack`
like so...

```bash
openstack server show precarious_puffin -c addresses
```

```plain
+-----------+--------------------------------------------+
| Field     | Value                                      |
+-----------+--------------------------------------------+
| addresses | ansible_net=10.254.254.198, 185.52.156.186 |
+-----------+--------------------------------------------+
```

...and then connect to the new server via SSH:

```bash
ssh -l ubuntu -i ansible_key \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    185.52.156.186
```

```plain
Warning: Permanently added '185.52.156.186' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-57-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri May 19 08:35:32 UTC 2023

  System load:  0.25439453125     Processes:             104
  Usage of /:   3.0% of 46.34GB   Users logged in:       0
  Memory usage: 5%                IPv4 address for ens3: 10.254.254.198
  Swap usage:   0%

0 updates can be applied immediately.

The list of available updates is more than a week old.
To check for new updates run: sudo apt update

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
```

Hit CTRL + D to exit the remote shell.

## Upgrade the server

You are now going to expand playbook `server.yml`, so it can also update
the system package cache and apply any available package upgrades. Open
up `server.yml` again and add content to make the playbook precisely
like this:

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Create server
      openstack.cloud.server:
        state: present
        name: precarious_puffin
        image: 'Ubuntu 22.04.1 Jammy Jellyfish 230124'
        flavor: b.2c4gb
        volume_size: 48
        boot_from_volume: true
        key_name: ansible_key
        network: ansible_net
        auto_ip: true
        security_groups: default
      register: vm_info

    - name: Add server to dynamic inventory
      add_host:
        name: '{{ vm_info.server.hostname }}'
        groups: cleura_cloud_servers
        ansible_ssh_host: '{{ vm_info.server.addresses.ansible_net[1].addr }}'

- hosts: cleura_cloud_servers
  gather_facts: true
  remote_user: ubuntu
  become: true

  tasks:
    - name: Update repositories package cache
      apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Apply package upgrades
      apt:
        upgrade: dist
        autoremove: true
        force_apt_get: true
```

Notice that the new content begins with the line `register: vm_info`,
which belongs to the existing `Create server` task. Overall, you
expanded a bit the first task of the first play, added a new task to it
(`Add server to dynamic inventory`), and then added a second play
(begins at `hosts: cleura_cloud_servers`) with two new tasks (`Update
repositories package cache` and `Apply package upgrades`).

Ask Ansible to run the updated playbook:

```bash
ansible-playbook server.yml
```

```plain
PLAY [localhost] ****************************************************************************************************************************

TASK [Create server] ************************************************************************************************************************
ok: [localhost]

TASK [Add server to dynamic inventory] ******************************************************************************************************
changed: [localhost]

PLAY [cleura_cloud_servers] *****************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************
ok: [precarious-puffin]

TASK [Update repositories package cache] ****************************************************************************************************
changed: [precarious-puffin]

TASK [Apply package upgrades] ***************************************************************************************************************
changed: [precarious-puffin]

PLAY RECAP **********************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
precarious-puffin          : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

The playbook might take some time to finish, especially if there are a
lot of available package upgrades.

## Reboot if required

Your new upgraded server may need a reboot. Let's expand the existing
playbook with two new tasks to accommodate that. After typing in the new
tasks at the end of the playbook, your `server.yaml` will look like
this:

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Create server
      openstack.cloud.server:
        state: present
        name: precarious_puffin
        image: 'Ubuntu 22.04.1 Jammy Jellyfish 230124'
        flavor: b.2c4gb
        volume_size: 48
        boot_from_volume: true
        key_name: ansible_key
        network: ansible_net
        auto_ip: true
        security_groups: default
      register: vm_info

    - name: Add server to dynamic inventory
      add_host:
        name: '{{ vm_info.server.hostname }}'
        groups: cleura_cloud_servers
        ansible_ssh_host: '{{ vm_info.server.addresses.ansible_net[1].addr }}'

- hosts: cleura_cloud_servers
  gather_facts: true
  remote_user: ubuntu
  become: true

  tasks:
    - name: Update repositories package cache
      apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Apply package upgrades
      apt:
        upgrade: dist
        autoremove: true
        force_apt_get: true

    - name: Check whether reboot is required
      stat:
        path: /var/run/reboot-required
      register: reboot_required_file

    - name: Initiate system reboot
      reboot:
      when: reboot_required_file.stat.exists
```

Have Ansible run the updated playbook:

```bash
ansible-playbook server.yml
```

```plain
PLAY [localhost] ****************************************************************************************************************************

TASK [Create server] ************************************************************************************************************************
ok: [localhost]

TASK [Add server to dynamic inventory] ******************************************************************************************************
changed: [localhost]

PLAY [cleura_cloud_servers] *****************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************
ok: [precarious-puffin]

TASK [Update repositories package cache] ****************************************************************************************************
ok: [precarious-puffin]

TASK [Apply package upgrades] ***************************************************************************************************************
ok: [precarious-puffin]

TASK [Check whether reboot is required] *****************************************************************************************************
ok: [precarious-puffin]

TASK [Initiate system reboot] ***************************************************************************************************************
changed: [precarious-puffin]

PLAY RECAP **********************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
precarious-puffin          : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Install, enable and start a service

Now that your server is fully up-to-date, it is a good time to add some
extra software. Go ahead and expand the playbook `server.yaml` by adding
two new tasks. In the end, the playbook should look like this:

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Create server
      openstack.cloud.server:
        state: present
        name: precarious_puffin
        image: 'Ubuntu 22.04.1 Jammy Jellyfish 230124'
        flavor: b.2c4gb
        volume_size: 48
        boot_from_volume: true
        key_name: ansible_key
        network: ansible_net
        auto_ip: true
        security_groups: default
      register: vm_info

    - name: Add server to dynamic inventory
      add_host:
        name: '{{ vm_info.server.hostname }}'
        groups: cleura_cloud_servers
        ansible_ssh_host: '{{ vm_info.server.addresses.ansible_net[1].addr }}'

- hosts: cleura_cloud_servers
  gather_facts: true
  remote_user: ubuntu
  become: true

  tasks:
    - name: Update repositories package cache
      apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Apply package upgrades
      apt:
        upgrade: dist
        autoremove: true
        force_apt_get: true

    - name: Check whether reboot is required
      stat:
        path: /var/run/reboot-required
      register: reboot_required_file

    - name: Initiate system reboot
      reboot:
      when: reboot_required_file.stat.exists

    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Enable and activate service nginx
      service:
        name: nginx
        enabled: true
        state: started
```

In the second play, right below the `Initiate system reboot` task, you
added two new tasks: `Install nginx` and `Enable and activate service
nginx`. That way, you made sure `nginx` is always installed on the
server and the corresponding Systemd service is enabled and started.
Now, ask Ansible to run the updated playbook:

```bash
ansible-playbook server.yml
```

```plain
PLAY [localhost] ****************************************************************************************************************************

TASK [Create server] ************************************************************************************************************************
ok: [localhost]

TASK [Add server to dynamic inventory] ******************************************************************************************************
changed: [localhost]

PLAY [cleura_cloud_servers] *****************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************
ok: [precarious-puffin]

TASK [Update repositories package cache] ****************************************************************************************************
changed: [precarious-puffin]

TASK [Apply package upgrades] ***************************************************************************************************************
ok: [precarious-puffin]

TASK [Check whether reboot is required] *****************************************************************************************************
ok: [precarious-puffin]

TASK [Initiate system reboot] ***************************************************************************************************************
skipping: [precarious-puffin]

TASK [Install nginx] ************************************************************************************************************************
changed: [precarious-puffin]

TASK [Enable and activate service nginx] ****************************************************************************************************
ok: [precarious-puffin]

PLAY RECAP **********************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
precarious-puffin          : ok=6    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

Optionally, you may check the `nginx` is up and answering client
requests by using `curl`:

```bash
curl http://185.52.156.186
```

```plain
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

## Delete cloud resources

You can use Ansible to delete objects in {{brand}}. Create a new
playbook named `tear-down.yml` with the below content:

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Delete server
      openstack.cloud.server:
        name: precarious_puffin
        state: absent

    - name: Delete router
      openstack.cloud.router:
        name: ansible_router
        state: absent

    - name: Delete subnet
      openstack.cloud.subnet:
        name: ansible_subnet
        state: absent

    - name: Delete network
      openstack.cloud.network:
        name: ansible_net
        state: absent

    - name: Delete keypair
      openstack.cloud.keypair:
        name: ansible_key
        state: absent
```

The playbook has one play with five tasks, each ensuring the
corresponding cloud resource is deleted. Ask Ansible to run the new
playbook:

```bash
ansible-playbook tear-down.yml
```

```plain
PLAY [localhost] ****************************************************************************************************************************

TASK [Delete server] ************************************************************************************************************************
changed: [localhost]

TASK [Delete router] ************************************************************************************************************************
changed: [localhost]

TASK [Delete subnet] ************************************************************************************************************************
changed: [localhost]

TASK [Delete network] ***********************************************************************************************************************
changed: [localhost]

TASK [Delete keypair] ***********************************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************
localhost                  : ok=5    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

You can use the `openstack` client to verify that all cloud resources
you created are gone.
