# Creating a VPN connection between regions

Thanks to the Openstack Neutron VPN as a Service (VPNaaS) feature, you
can bridge two different regions via a site-to-site IPSec VPN
connection. This is made possible without setting up and configuring a
virtual machine in any one of the regions. On the contrary, you can
quickly establish such a connection using the {{gui}} or the OpenStack
CLI. Let us demonstrate the process following both approaches.

## Prerequisites

Whether you choose to work from the {{gui}} or with the OpenStack CLI,
you need to [have an account](../../getting-started/create-account.md) in
{{brand}}. If you prefer to work with the [OpenStack
CLI](../../getting-started/enable-openstack-cli.md), then in addition to
the Python `openstackclient` module, you need to install the
Python `neutronclient` module also. Use either the package manager
of your operating system or `pip`:

=== "Debian/Ubuntu"
    ```bash
    apt install python3-neutronclient
    ```
=== "Mac OS X with Homebrew"
    This Python module is unavailable via `brew`, but you can
    install it via `pip`.
=== "Python Package"
    ```bash
    pip install python-neutronclient
    ```

## Creating a VPN connection between two regions

To create and establish such a connection from the {{gui}}, fire up
your favorite web browser, navigate to the
[{{gui}}](https://compliant.{{brand_domain}}) start page, and log into your
{{brand}} account. Should you decide to follow the OpenStack CLI route
instead, please make sure you have the appropriate [RC
file](../../getting-started/enable-openstack-cli.md) for each region
involved.

=== "{{gui}}"
    On the top right-hand side of the {{gui}}, click the _Create_
    button. A vertical pane titled _Create_ will slide into view from the
    right-hand side of the browser window. You will notice several rounded
    boxes, each one for defining, configuring, and instantiating a
    different {{brand}} object. Go ahead and click the _VPN_ box.

    ![Create new object](assets/vpnaas/shot-01.png)

    A new pane titled _Create a VPN Service_ will slide over. Between
    the two boxes, click the one titled _Quick (Guided) Connect_.

    ![Quick connect](assets/vpnaas/shot-02.png)

    Type in a name for the new site-to-site VPN connection.

    ![Connection name](assets/vpnaas/shot-03.png)

    Select a region, project, and network for each of the two data
    centers involved.

    ![Data center choices](assets/vpnaas/shot-04.png)

    Look at the pre-shared key and, optionally, expand the _Advanced
    Options_ section to see all presets. You do not have to change anything
    there. When you are ready, click the green _Create_ button. The VPN
    connection between the two regions will be established in a few seconds.

    ![Create](assets/vpnaas/shot-05.png)
=== "OpenStack CLI"
    First, you need to have the RC files of the two regions you will be
    connecting. In the example that follows, we demonstrate establishing a
    site-to-site connection between regions `Sto-Com` and `Sto1HS`. This means
    that, while following through, before working in `Sto-Com` you need to
    source the RC file for `Sto-Com`, and before working in `Sto1HS` you need
    to source the RC file for `Sto1HS`.

    > It helps to imagine the site-to-site connection schematically,
    with `Sto-Com` being on the left side and `Sto1HS` being on the right side
    of the connection. That is why we interchange the terms `Sto-Com`, _left_
    and `Sto1HS`, _right_.

    You also have to decide which subnets from either side you will
    connect. Additionally, you need to know the respective CIDR notations
    and routers. In the examples that follow, on the left side we have
    subnet `subnet-stocom` with CIDR `10.15.25.0/24` and router
    `router-stocom`, and on the right side we have subnet `subnet-sto1hs` with
    CIDR `10.15.20.0/24` and router `router-sto1hs`. For convenience, we have
    set the shell variables `SUBNET_STOCOM` and `SUBNET_STO1HS`:

    ```bash
    SUBNET_STOCOM="10.15.25.0/24"
    SUBNET_STO1HS="10.15.20.0/24"
    ```

    ### Prepare the left side (region `Sto-Com`)

    Begin by creating a new
    [IKE](https://en.wikipedia.org/wiki/Internet_Key_Exchange) policy:

    ```bash
    openstack vpn ike policy create ike-pol-stocom
    ```

    ```plain
    +-------------------------------+--------------------------------------+
    | Field                         | Value                                |
    +-------------------------------+--------------------------------------+
    | Authentication Algorithm      | sha1                                 |
    | Description                   |                                      |
    | Encryption Algorithm          | aes-128                              |
    | ID                            | ea762a7b-5882-42b0-9e37-164964925efc |
    | IKE Version                   | v1                                   |
    | Lifetime                      | {'units': 'seconds', 'value': 3600}  |
    | Name                          | ike-pol-stocom                       |
    | Perfect Forward Secrecy (PFS) | group5                               |
    | Phase1 Negotiation Mode       | main                                 |
    | Project                       | d42230ea21674515ab9197af89fa5192     |
    +-------------------------------+--------------------------------------+
    ```

    Then, create a new [IPSec](https://en.wikipedia.org/wiki/IPsec)
    policy:

    ```bash
    openstack vpn ipsec policy create ipsec-pol-stocom
    ```

    ```plain
    +-------------------------------+--------------------------------------+
    | Field                         | Value                                |
    +-------------------------------+--------------------------------------+
    | Authentication Algorithm      | sha1                                 |
    | Description                   |                                      |
    | Encapsulation Mode            | tunnel                               |
    | Encryption Algorithm          | aes-128                              |
    | ID                            | 5d384ac0-4d9e-4ff2-b0c4-c24aae757625 |
    | Lifetime                      | {'units': 'seconds', 'value': 3600}  |
    | Name                          | ipsec-pol-stocom                     |
    | Perfect Forward Secrecy (PFS) | group5                               |
    | Project                       | d42230ea21674515ab9197af89fa5192     |
    | Transform Protocol            | esp                                  |
    +-------------------------------+--------------------------------------+
    ```

    You are ready to create a new VPN service:

    ```bash
    openstack vpn service create --router router-stocom vpn-service-stocom
    ```

    ```plain
    +-------------+--------------------------------------+
    | Field       | Value                                |
    +-------------+--------------------------------------+
    | Description |                                      |
    | Ext v4 IP   | 198.51.100.50                        |
    | Ext v6 IP   | None                                 |
    | Flavor      | None                                 |
    | ID          | 5cd9955b-556d-4429-839b-f8b16984823c |
    | Name        | vpn-service-stocom                   |
    | Project     | d42230ea21674515ab9197af89fa5192     |
    | Router      | 20d08308-acd2-4806-8a8b-267c2d8e3616 |
    | State       | True                                 |
    | Status      | PENDING_CREATE                       |
    | Subnet      | None                                 |
    +-------------+--------------------------------------+
    ```

    Notice in the command output that the `Status` is `PENDING_CREATE`.
    This is expected. Also, jot down the value of the `Ext v4 IP`.
    Better yet, set this value to a new variable, `EXT_IP_STOCOM`,
    for you will soon need it:

    ```bash
    EXT_IP_STOCOM="198.51.100.50"
    ```

    The site-to-site connection you are about to create needs two
    end-point groups on the left, and two end-point groups on the right.
    More specifically, on either side of the connection, there should be
    one end-point group for the local subnet and one end-point group for
    the peer (remote) subnet. You are now on the left side of the
    connection (region `Sto-Com`), so begin with the left local end-point
    group...

    ```bash
    openstack vpn endpoint group create \
        --type subnet --value subnet-stocom local-epg-stocom
    ```

    ```plain
    +-------------+------------------------------------------+
    | Field       | Value                                    |
    +-------------+------------------------------------------+
    | Description |                                          |
    | Endpoints   | ['f3437683-88a3-40a3-89c4-021bed3a2ccf'] |
    | ID          | b30469fa-a7ce-4778-85eb-700dd4d029fb     |
    | Name        | local-epg-stocom                         |
    | Project     | d42230ea21674515ab9197af89fa5192         |
    | Type        | subnet                                   |
    +-------------+------------------------------------------+
    ```

    ...and then move on to creating the left peer end-point group:

    ```bash
    openstack vpn endpoint group create \
        --type cidr --value $SUBNET_STO1HS peer-epg-stocom
    ```

    ```plain
    +-------------+--------------------------------------+
    | Field       | Value                                |
    +-------------+--------------------------------------+
    | Description |                                      |
    | Endpoints   | ['10.15.20.0/24']                    |
    | ID          | 097f46ef-01f6-4a3f-b4c7-3f9639e77c50 |
    | Name        | peer-epg-stocom                      |
    | Project     | d42230ea21674515ab9197af89fa5192     |
    | Type        | cidr                                 |
    +-------------+--------------------------------------+
    ```

    ### Prepare the right side (region `Sto1HS`)

    Before establishing a site-to-site VPN connection between the two
    regions, you must make similar preparations on the right side of the
    connection (region `sto1hs`). You should adjust all commands you entered
    above and execute them on the right side. For your convenience, these
    are all the adjusted commands with the respective outputs:

    Create a new IKE policy:

    ```bash
    openstack vpn ike policy create ike-pol-sto1hs
    ```

    ```plain
    +-------------------------------+--------------------------------------+
    | Field                         | Value                                |
    +-------------------------------+--------------------------------------+
    | Authentication Algorithm      | sha1                                 |
    | Description                   |                                      |
    | Encryption Algorithm          | aes-128                              |
    | ID                            | 6d5b184e-75b6-4ba8-9683-fdd8af929ded |
    | IKE Version                   | v1                                   |
    | Lifetime                      | {'units': 'seconds', 'value': 3600}  |
    | Name                          | ike-pol-sto1hs                       |
    | Perfect Forward Secrecy (PFS) | group5                               |
    | Phase1 Negotiation Mode       | main                                 |
    | Project                       | 90b7fe7b32ca4a7bbce520bd7569bbf6     |
    +-------------------------------+--------------------------------------+
    ```

    Create a new IPSec policy:

    ```bash
    openstack vpn ipsec policy create ipsec-pol-sto1hs
    ```

    ```plain
    +-------------------------------+--------------------------------------+
    | Field                         | Value                                |
    +-------------------------------+--------------------------------------+
    | Authentication Algorithm      | sha1                                 |
    | Description                   |                                      |
    | Encapsulation Mode            | tunnel                               |
    | Encryption Algorithm          | aes-128                              |
    | ID                            | f81a3759-f8fd-4d13-b341-7ce9f477aa7f |
    | Lifetime                      | {'units': 'seconds', 'value': 3600}  |
    | Name                          | ipsec-pol-sto1hs                     |
    | Perfect Forward Secrecy (PFS) | group5                               |
    | Project                       | 90b7fe7b32ca4a7bbce520bd7569bbf6     |
    | Transform Protocol            | esp                                  |
    +-------------------------------+--------------------------------------+
    ```

    Create a new VPN service:

    ```bash
    openstack vpn service create --router router-sto1hs vpn-service-sto1hs
    ```

    ```plain
    +-------------+--------------------------------------+
    | Field       | Value                                |
    +-------------+--------------------------------------+
    | Description |                                      |
    | Ext v4 IP   | 203.0.113.101                        |
    | Ext v6 IP   | 2a06:2981:502:2:f816:3eff:fe69:1c69  |
    | Flavor      | None                                 |
    | ID          | 758fbedd-ca42-412a-8416-8473137b0361 |
    | Name        | vpn-service-sto1hs                   |
    | Project     | 90b7fe7b32ca4a7bbce520bd7569bbf6     |
    | Router      | 8d02e2d0-0465-458d-af32-280c51e5daa5 |
    | State       | True                                 |
    | Status      | PENDING_CREATE                       |
    | Subnet      | None                                 |
    +-------------+--------------------------------------+
    ```

    For convenience, set the value of parameter `Ext v4 IP` to a
    shell variable:

    ```bash
    EXT_IP_STO1HS="203.0.113.101"
    ```

    Create a local end-point group:

    ```bash
    openstack vpn endpoint group create \
        --type subnet --value subnet-sto1hs local-epg-sto1hs
    ```

    ```plain
    +-------------+------------------------------------------+
    | Field       | Value                                    |
    +-------------+------------------------------------------+
    | Description |                                          |
    | Endpoints   | ['a8f7a054-37cc-40f0-8d23-b1d3c0bbec99'] |
    | ID          | a2c76a28-96b1-4006-afcf-4ded83786a42     |
    | Name        | local-epg-sto1hs                         |
    | Project     | 90b7fe7b32ca4a7bbce520bd7569bbf6         |
    | Type        | subnet                                   |
    +-------------+------------------------------------------+
    ```

    Create a peer (remote) end-point group:

    ```bash
    openstack vpn endpoint group create \
        --type cidr --value $SUBNET_STOCOM peer-epg-sto1hs
    ```

    ```plain
    +-------------+------------------------------------------+
    | Field       | Value                                    |
    +-------------+------------------------------------------+
    | Description |                                          |
    | Endpoints   | ['a8f7a054-37cc-40f0-8d23-b1d3c0bbec99'] |
    | ID          | 0c1adeba-42a3-430e-afeb-daa002285be7     |
    | Name        | local-epg-sto1hs                         |
    | Project     | 90b7fe7b32ca4a7bbce520bd7569bbf6         |
    | Type        | subnet                                   |
    +-------------+------------------------------------------+
    ```

    ### Instantiate a pre-shared key

    Before establishing a site-to-site IPSec VPN connection, you must
    have a randomly generated pre-shared key. You may use `openssl` for
    generating a random string and immediately set it to a shell variable:

    ```bash
    PRE_SHARED_KEY=$(openssl rand -hex 24)
    ```

    The above is just an example. The key should not necessarily be a
    hexadecimal string, nor do you have to use `openssl`. Another option
    would be to use the fine `pwgen` tool, for example like this:

    ```bash
    PRE_SHARED_KEY=$(pwgen 64 1)
    ```

    ### Establish a left-to-right connection (region `Sto-Com`)

    To create a VPN connection from left to right, i.e., from region
    `Sto-Com` to region `Sto1HS`, issue the following command:

    ```bash
    openstack vpn ipsec site connection create \
      --vpnservice vpn-service-stocom \
      --ikepolicy ike-pol-stocom \
      --ipsecpolicy ipsec-pol-stocom \
      --local-endpoint-group local-epg-stocom \
      --peer-address $EXT_IP_STO1HS \
      --peer-id $EXT_IP_STO1HS \
      --peer-endpoint-group peer-epg-stocom \
      --psk $PRE_SHARED_KEY \
      vpn-conn-to-sto1hs
    ```

    ```plain
    +--------------------------+------------------------------------------------------------------+
    | Field                    | Value                                                            |
    +--------------------------+------------------------------------------------------------------+
    | Authentication Algorithm | psk                                                              |
    | DPD                      | {'action': 'hold', 'interval': 30, 'timeout': 120}               |
    | Description              |                                                                  |
    | ID                       | 522f0cd6-b82b-4fae-88cc-89709f6fcacf                             |
    | IKE Policy               | ea762a7b-5882-42b0-9e37-164964925efc                             |
    | IPSec Policy             | 5d384ac0-4d9e-4ff2-b0c4-c24aae757625                             |
    | Initiator                | bi-directional                                                   |
    | Local Endpoint Group ID  | b30469fa-a7ce-4778-85eb-700dd4d029fb                             |
    | Local ID                 |                                                                  |
    | MTU                      | 1500                                                             |
    | Name                     | vpn-conn-to-sto1hs                                               |
    | Peer Address             | 203.0.113.101                                                    |
    | Peer CIDRs               |                                                                  |
    | Peer Endpoint Group ID   | 097f46ef-01f6-4a3f-b4c7-3f9639e77c50                             |
    | Peer ID                  | 203.0.113.101                                                    |
    | Pre-shared Key           | phui0moRoobeeX3toh2eekooHo1beepaik1CooXi6aepuwahc5ShaeN6daifoh8a |
    | Project                  | d42230ea21674515ab9197af89fa5192                                 |
    | Route Mode               | static                                                           |
    | State                    | True                                                             |
    | Status                   | PENDING_CREATE                                                   |
    | VPN Service              | 5cd9955b-556d-4429-839b-f8b16984823c                             |
    +--------------------------+------------------------------------------------------------------+
    ```

    ### Establish a right-to-left connection (region `Sto1HS`)

    Similarly, to create a VPN connection from right to left, i.e.,
    from region `Sto1HS` to region `Sto-Com`, issue the following command:

    ```bash
    openstack vpn ipsec site connection create \
      --vpnservice vpn-service-sto1hs \
      --ikepolicy ike-pol-sto1hs \
      --ipsecpolicy ipsec-pol-sto1hs \
      --local-endpoint-group local-epg-sto1hs \
      --peer-address $EXT_IP_STOCOM \
      --peer-id $EXT_IP_STOCOM \
      --peer-endpoint-group peer-epg-sto1hs \
      --psk $PRE_SHARED_KEY \
      vpn-conn-to-stocom
    ```

    ```plain
    +--------------------------+------------------------------------------------------------------+
    | Field                    | Value                                                            |
    +--------------------------+------------------------------------------------------------------+
    | Authentication Algorithm | psk                                                              |
    | DPD                      | {'action': 'hold', 'interval': 30, 'timeout': 120}               |
    | Description              |                                                                  |
    | ID                       | b826b309-803b-433b-9485-3d9bcb7580ae                             |
    | IKE Policy               | 6d5b184e-75b6-4ba8-9683-fdd8af929ded                             |
    | IPSec Policy             | f81a3759-f8fd-4d13-b341-7ce9f477aa7f                             |
    | Initiator                | bi-directional                                                   |
    | Local Endpoint Group ID  | a2c76a28-96b1-4006-afcf-4ded83786a42                             |
    | Local ID                 |                                                                  |
    | MTU                      | 1500                                                             |
    | Name                     | vpn-conn-to-stocom                                               |
    | Peer Address             | 198.51.100.50                                                    |
    | Peer CIDRs               |                                                                  |
    | Peer Endpoint Group ID   | 0c8caef6-1106-42d0-a965-d0a286349e60                             |
    | Peer ID                  | 198.51.100.50                                                    |
    | Pre-shared Key           | phui0moRoobeeX3toh2eekooHo1beepaik1CooXi6aepuwahc5ShaeN6daifoh8a |
    | Project                  | 90b7fe7b32ca4a7bbce520bd7569bbf6                                 |
    | Route Mode               | static                                                           |
    | State                    | True                                                             |
    | Status                   | PENDING_CREATE                                                   |
    | VPN Service              | 758fbedd-ca42-412a-8416-8473137b0361                             |
    +--------------------------+------------------------------------------------------------------+
    ```

## Viewing VPN connections and getting details

No matter if you use the {{gui}} or the OpenStack CLI, you may at any
time list all VPN connections and get relevant details.

=== "{{gui}}"
    In the vertical pane on the left-hand side of the {{gui}}, expand
    the _Networking_ section and then the _VPN Services_ subsection. From
    the available options, click _VPN Services_ again. You will see two VPN
    connections in the main pane, each from one region to the other.

    ![Create](assets/vpnaas/shot-06.png)

    For more information regarding a specific connection, click the
    corresponding three-dot icon (right-hand side) and select _View
    details_. Then, you can glance over all the details regarding, for
    example, the connection status and public IP address.

    ![Create](assets/vpnaas/shot-07.png)
=== "OpenStack CLI"
    You can list all IPSec VPN connections working from any of the two
    regions involved. See, for example, the view from `sto-com`:

    ```bash
    openstack vpn ipsec site connection list
    ```

    ```plain
    +--------------------------------------+--------------------+----------------+--------------------------+--------+
    | ID                                   | Name               | Peer Address   | Authentication Algorithm | Status |
    +--------------------------------------+--------------------+----------------+--------------------------+--------+
    | 522f0cd6-b82b-4fae-88cc-89709f6fcacf | vpn-conn-to-sto1hs | 203.0.113.101  | psk                      | ACTIVE |
    +--------------------------------------+--------------------+----------------+--------------------------+--------+
    ```

    If you want more information regarding a specific connection, type
    something like this:

    ```bash
    openstack vpn ipsec site connection show vpn-conn-to-sto1hs
    ```

    ```plain
    +--------------------------+------------------------------------------------------------------+
    | Field                    | Value                                                            |
    +--------------------------+------------------------------------------------------------------+
    | Authentication Algorithm | psk                                                              |
    | DPD                      | {'action': 'hold', 'interval': 30, 'timeout': 120}               |
    | Description              |                                                                  |
    | ID                       | 522f0cd6-b82b-4fae-88cc-89709f6fcacf                             |
    | IKE Policy               | ea762a7b-5882-42b0-9e37-164964925efc                             |
    | IPSec Policy             | 5d384ac0-4d9e-4ff2-b0c4-c24aae757625                             |
    | Initiator                | bi-directional                                                   |
    | Local Endpoint Group ID  | b30469fa-a7ce-4778-85eb-700dd4d029fb                             |
    | Local ID                 |                                                                  |
    | MTU                      | 1500                                                             |
    | Name                     | vpn-conn-to-sto1hs                                               |
    | Peer Address             | 203.0.113.101                                                    |
    | Peer CIDRs               |                                                                  |
    | Peer Endpoint Group ID   | 097f46ef-01f6-4a3f-b4c7-3f9639e77c50                             |
    | Peer ID                  | 203.0.113.101                                                    |
    | Pre-shared Key           | phui0moRoobeeX3toh2eekooHo1beepaik1CooXi6aepuwahc5ShaeN6daifoh8a |
    | Project                  | d42230ea21674515ab9197af89fa5192                                 |
    | Route Mode               | static                                                           |
    | State                    | True                                                             |
    | Status                   | ACTIVE                                                           |
    | VPN Service              | 5cd9955b-556d-4429-839b-f8b16984823c                             |
    +--------------------------+------------------------------------------------------------------+
    ```

## Testing the site-to-site VPN connection

One way to test the VPN connection is to have two servers (e.g.,
`server-stocom` and `server-sto1hs`), each on a different region (e.g.,
`Sto-Com` and `Sto1HS` respectively), ping each other using private IP
addresses. With no VPN connection between the two regions, pinging
should not be possible:

```console
ubuntu@server-stocom:~$ ping -c 3 10.15.20.120
PING 10.15.20.120 (10.15.20.120) 56(84) bytes of data.

--- 10.15.20.120 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2050ms
```

```console
ubuntu@server-sto1hs:~$ ping -c 3 10.15.25.130
PING 10.15.25.130 (10.15.25.130) 56(84) bytes of data.

--- 10.15.25.130 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2045ms
```

On the other hand, with a VPN connection established between the two
regions, pinging should be all possible:

```console
ubuntu@server-stocom:~$ ping -c 3 10.15.20.120
PING 10.15.20.120 (10.15.20.120) 56(84) bytes of data.
64 bytes from 10.15.20.120: icmp_seq=1 ttl=62 time=32.8 ms
64 bytes from 10.15.20.120: icmp_seq=2 ttl=62 time=32.5 ms
64 bytes from 10.15.20.120: icmp_seq=3 ttl=62 time=32.6 ms

--- 10.15.20.120 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 32.544/32.624/32.761/0.096 ms
```

```console
ubuntu@server-sto1hs:~$ ping -c 3 10.15.25.130
PING 10.15.25.130 (10.15.25.130) 56(84) bytes of data.
64 bytes from 10.15.25.130: icmp_seq=1 ttl=62 time=33.3 ms
64 bytes from 10.15.25.130: icmp_seq=2 ttl=62 time=32.5 ms
64 bytes from 10.15.25.130: icmp_seq=3 ttl=62 time=32.6 ms

--- 10.15.25.130 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 32.533/32.832/33.336/0.358 ms
```

## Disabling an active connection

You may, at any time, disable an active site-to-site VPN connection.

=== "{{gui}}"
    Currently, there is no way to disable an active connection from the
    {{gui}}. If you want to disable an active connection, please use the
    OpenStack CLI.
=== "OpenStack CLI"
    All you have to do is get on either side of the connection and
    disable the VPN connection across the other side. Suppose you are on
    the left side of the connection (region `Sto-Com`), and for whatever
    reason, you want to disable the site-to-site connection between left
    and right (regions `Sto-Com` and `Sto1HS`). First, you might want to
    remember the name of the VPN connection to the right:

    ```bash
    openstack vpn ipsec site connection list
    ```

    ```plain
    +--------------------------------------+--------------------+----------------+--------------------------+--------+
    | ID                                   | Name               | Peer Address   | Authentication Algorithm | Status |
    +--------------------------------------+--------------------+----------------+--------------------------+--------+
    | 522f0cd6-b82b-4fae-88cc-89709f6fcacf | vpn-conn-to-sto1hs | 203.0.113.101  | psk                      | ACTIVE |
    +--------------------------------------+--------------------+----------------+--------------------------+--------+
    ```

    That would be `vpn-conn-to-sto1hs`, and according to the command
    output above, it is active. To disable it, type the following:

    ```bash
    openstack vpn ipsec site connection set --disable vpn-conn-to-sto1hs
    ```

    Check if it is really disabled:

    ```bash
    openstack vpn ipsec site connection show vpn-conn-to-sto1hs -c Status
    ```

    ```plain
    +--------+-------+
    | Field  | Value |
    +--------+-------+
    | Status | DOWN  |
    +--------+-------+
    ```

    It looks like it is disabled --- or `DOWN`.

    > You will probably have to wait several seconds before seeing a
    status change. If you are impatient, try something like this:
    ```bash
    watch "openstack vpn ipsec site connection show vpn-conn-to-sto1hs -c Status"
    ```
    Hit CTRL+C as soon as you see the status change you expect.

    Now, get on the right side of the connection (region `Sto1HS`),
    optionally look for the name of the VPN connection to the left (in our
    example, that would be `vpn-conn-to-stocom`), and check its status:

    ```bash
    openstack vpn ipsec site connection show vpn-conn-to-stocom -c Status
    ```

    ```plain
    +--------+-------+
    | Field  | Value |
    +--------+-------+
    | Status | DOWN  |
    +--------+-------+
    ```

    It turns out that this direction of the connection is also disabled.

To test that a previously enabled site-to-site connection is now disabled,
select a server from one region and try to ping a server in another region.
Suppose, for example, that a now-disabled connection involved regions
`Sto-Com` and `Sto1HS`, and that we have servers `server-stocom` (in `Sto-Com`) and
`server-sto1hs` (in `Sto1HS`). With the VPN connection between the two regions
now disabled, pinging should not be possible:

```console
ubuntu@server-stocom:~$ ping -c 3 10.15.20.120
PING 10.15.20.120 (10.15.20.120) 56(84) bytes of data.

--- 10.15.20.120 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2055ms
```

```console
ubuntu@server-sto1hs:~$ ping -c 3 10.15.25.130
PING 10.15.25.130 (10.15.25.139) 56(84) bytes of data.

--- 10.15.25.130 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2050ms
```

## Enabling an inactive connection

You can easily enable an inactive site-to-site VPN connection.

=== "{{gui}}"
    Currently, there is no way to enable an inactive connection from
    the {{gui}}. If you want to re-enable an inactive connection,
    please use the OpenStack CLI.
=== "OpenStack CLI"
    Make sure you hop on the side where you initially disabled the
    connection. According to the example scenario we described in the
    previous section, that would be the left side (region `Sto-Com`), and the
    name of the disabled connection would be `vpn-conn-to-sto1hs`. Make sure
    the connection status is `DOWN`:

    ```bash
    openstack vpn ipsec site connection show vpn-conn-to-sto1hs -c Status
    ```

    ```plain
    +--------+-------+
    | Field  | Value |
    +--------+-------+
    | Status | DOWN  |
    +--------+-------+
    ```

    Note that if you issued a similar command from the right side of
    the connection (region `sto1hs`), you would also get a `DOWN` status.
    Being on the left side, all you have to do to enable the inactive
    connection is type the following:

    ```bash
    openstack vpn ipsec site connection set --enable vpn-conn-to-sto1hs
    ```

    Check the connection status --- it should be `ACTIVE`:

    ```bash
    openstack vpn ipsec site connection show vpn-conn-to-sto1hs -c Status
    ```

    ```plain
    +--------+--------+
    | Field  | Value  |
    +--------+--------+
    | Status | ACTIVE |
    +--------+--------+
    ```

    You get the same status by issuing a similar command from the right
    side.

    > Again, since you may have to wait several seconds before seeing
    the status change you expect, try something like this:
    ```bash
    watch "openstack vpn ipsec site connection show vpn-conn-to-sto1hs -c Status"
    ```
    Hit CTRL+C to stop watching.

To test that a previously disabled site-to-site connection is now enabled,
select a server from one region and try to ping a server in another region.
Suppose, for example, that a re-enabled connection involves regions
`Sto-Com` and `sto1hs`, and that we have servers `server-stocom` (in `Sto-Com`) and
`server-sto1hs` (in `Sto1HS`). With the VPN connection between the two regions
now re-established, pinging should be possible:

```console
ubuntu@server-stocom:~$ ping -c 3 10.15.20.120
PING 10.15.20.120 (10.15.20.120) 56(84) bytes of data.
64 bytes from 10.15.20.120: icmp_seq=1 ttl=62 time=32.6 ms
64 bytes from 10.15.20.120: icmp_seq=2 ttl=62 time=32.6 ms
64 bytes from 10.15.20.120: icmp_seq=3 ttl=62 time=32.7 ms

--- 10.15.20.120 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 32.619/32.634/32.662/0.019 ms
```

```console
ubuntu@server-sto1hs:~$ ping -c 3 10.15.25.130
PING 10.15.25.58 (10.15.25.58) 56(84) bytes of data.
64 bytes from 10.15.25.130: icmp_seq=1 ttl=62 time=32.8 ms
64 bytes from 10.15.25.130: icmp_seq=2 ttl=62 time=32.6 ms
64 bytes from 10.15.25.130: icmp_seq=3 ttl=62 time=33.4 ms

--- 10.15.25.130 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 32.560/32.899/33.357/0.336 ms
```
