# Securing your control node

Since your Ansible control host will be able to reach (potentially) every system in your environment, it is very important to employ good security practices.

## Use dedicated Ansible user account

Create a dedicated ansible user.

```sh
sudo useradd ansible
```

Note that the account that gets created as part of the server in the {{gui}} should be considered an administrative account as it has passwordless root access via sudo.
This is not desirable for the ansible user in the case of the control host itself.

In order for your automation engineers to be able to run ansible playbooks from your control host they need access to the ansible user.
One way is to have a group, `ansible-operators`, that has privileges to run commands as the `ansible` user via sudo.

Utilizing sudo and not allowing direct login as the ansible user has the advantage of creating traceability of who is escalating themselves at what time.

```sh
sudo vi /etc/sudoers.d/99-ansible-operators
```

The following sudoers line permits the group `ansible-operators` on the host `ansible-ctrl`to run `ALL` commands as the `ansible` user by providing their password.

```plain
%ansible-operators ansible-ctrl=(ansible) ALL
```

An `ansible-operators` member can then escalate themselves by typing:

```sh
sudo -i -u ansible
```

For all managed hosts, the ansible user on the control host will need to be able to acquire root privileges.

On your control host, create a password protected ssh key-pair as the ansible user.

```sh
sudo -i -u ansible
ssh-keygen -t ed25519 -C "Ansible"
```

On your managed host, create a matching ansible user with a strong password and enable privilege escalation via sudo.

```sh
sudo useradd ansible
sudo passwd ansible
sudo echo "ansible ALL=(root) ALL" > /etc/sudoers.d/99-ansible
```

Copy the ssh public key from your control host to the managed host.

```sh
sudo -i -u ansible
ssh-copy-id <hostname or ip>
```

Note: This requires that you temporarily enable password authentication for ssh at your managed host.
Don't forget to disable it immediately when you're done copying the key over.
