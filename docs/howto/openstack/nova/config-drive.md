# Launching a server with a configuration drive


## Background: OpenStack metadata discovery

OpenStack Compute uses metadata to inject custom configurations to
servers on boot. You can add custom scripts, install packages, and
add SSH keys to the servers using metadata.

By default, metadata discovery in {{brand}} Cloud uses an HTTP
data source that booting servers connect to. Sometimes this is
undesirable or — for specific server/networking configurations —
unreliable. Under those circumstances, you can use an alternate
configuration source.


## Store metadata on a configuration drive

A **configuration drive** (config drive) is a read-only virtual drive
that is attached to a server during boot. The server can then
mount the drive and read files from it. Configuration drives are used
as a data source for
[cloud-init](https://cloudinit.readthedocs.io/en/latest/).


## Enable the configuration drive on server creation (`openstack` CLI)

To enable the configuration drive, you need to pass the parameter
`--use-config-drive` to the `openstack server create` command.

In the following example, replace the image, flavor, keypair, and
network reference, as well as the server name, to match your desired
configuration.

```bash
openstack server create \
  --use-config-drive \
  --image "Ubuntu 20.04 Focal Fossa" \
  --flavor b.1c2gb \
  --keypair mykey
  --nic net-id=3a747038-ee59-404c-973d-5f795e8ebb73 \
  myserver
```

Once the server launches, you can monitor its configuration process
by monitoring the server console log:

```bash
openstack console log show myserver
```

