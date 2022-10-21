# Creating a new network

Before creating a server in {{extra.brand}} Cloud, you need to have a
network to make the new server a member of. You may have more than one
network per region, so let us now walk through creating a new network.

=== "Cleura Cloud Control Panel"
    Fire up your favorite web browser, navigate to the [Cleura
    Cloud](https://{{extra.gui_domain}}) page, and login into your
    {{extra.brand}} account.

    On the top right-hand side of the {{extra.gui}}, click the _Create_
    button. A new pane will slide into view from the right-hand side of
    the browser window, titled _Create_.

    ![Create a new object](assets/new-net-panel/shot-01.png)

    You will notice several rounded boxes prominently displayed on that 
    pane, each for defining, configuring, and instantiating a different 
    {{extra.brand}} Cloud object. Go ahead and click the _Network_ box. A 
    new pane titled _Create Network_ will slide over. At the top, type in a 
    name and select one of the available regions for the new network.

    ![New network name and region](assets/new-net-panel/shot-02.png)

    Expand the _Advanced Options_ section below, make sure _Port 
    Security_ is enabled, and leave the MTU parameter blank.

    ![MTU and port security](assets/new-net-panel/shot-03.png)
=== "`openstack` CLI"
    !!! warning "TODO"


## Adding a subnet and router

You probably want a full-featured network for your cloud servers,
which means that besides the network object, you will need to create a
*subnet,* and a *router* that connects your network to the outside
internet.

=== "Cleura Cloud Control Panel"
    Please activate the _Create a complete network containing a subnet and a router_
    option. You will notice that
    [a network address in CIDR notation](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation)
    is pre-configured for your network. You also get a couple of
    DNS servers, a Gateway, and a DHCP server.

    ![Complete network](assets/new-net-panel/shot-04.png)

    Scroll down a little bit if you have to. Assuming you want your cloud 
    servers to reach hosts on the Internet, for _External network_ make 
    sure you select _ext-net_. Then, click the green _Create_ button to 
    create the new network.

    ![Finish creating network](assets/new-net-panel/shot-05.png)

    In a few seconds, the new network will be readily available. You may 
    see all defined networks, in all supported regions, by selecting 
    _Networking_ > _Networks_ (see the left-hand side pane on the 
    {{extra.gui}}).

    ![All networks in all regions](assets/new-net-panel/shot-06.png)
=== "`openstack` CLI"
    !!! warning "TODO"


## Listing network information

In order to retrieve the configuration about your newly created
network, subnet, and router, proceed as follows.

=== "Cleura Cloud Control Panel"
    For more information regarding a specific network, click the 
    corresponding three-dot icon (right-hand side) and select _View 
    details_. Then, you can glance over all the details regarding the 
    selected network's ports, subnets, and routers.

    ![Network details](assets/new-net-panel/shot-07.png)
=== "`openstack` CLI"
    !!! warning "TODO"
