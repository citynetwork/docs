---
description: How to deploy a Matomo instance in Cleura Cloud
---

# Creating a Matomo instance

This guide covers the deployment of a self-hosted [Matomo](https://matomo.org/) service.

To proceed, make sure you have an [account in {{brand}}](../../getting-started/create-account.md), and you are logged in to the [{{gui}}](https://{{gui_domain}}).

## Step-by-step deployment

In the left vertical pane of the {{gui}}, expand the *Marketplace* category and click on *Discover Apps and Services*.
In the central pane, you will see all available applications and services.
Locate the *Matomo* box and click the green *View* button.

![Select the Matomo application](assets/new-matomo/matomo-01.png)

You will see the *Matomo* information page, where you can learn more about its features, and obtain pricing information.
Click the orange *Deploy this App* button to start the deployment process.

![Start the Matomo deployment process](assets/new-matomo/matomo-02.png)

The Matomo application is hosted on a [Nova VM](../../openstack/nova/new-server.md), so now you may select a region, a name, a flavor, a public network, a keypair, and a security group for it.
Regarding the security group, [make sure it includes a rule](../../openstack/neutron/create-security-groups.md) allowing incoming TCP connections to port 80.

Read and agree to the *Terms and Conditions.*
When you are ready, click the green *Create* button.

![Specify the characteristics of the particular Matomo deployment](assets/new-matomo/matomo-03.png)

The deployment takes some minutes to complete.
To check how it is going, expand the Marketplace category in the vertical pane on the left and click *Provisioned Apps*.
In the central pane, watch the Matomo Heat stack row.
The animated icon at the left marks the deployment progress.

![Check the deployment progress](assets/new-matomo/matomo-04.png)

When the deployment is complete, you will see a white check mark in a green circle.

![Matomo is deployed](assets/new-matomo/matomo-05.png)

## Logging into the Matomo dashboard

Next, you need the URL of your Matomo instance.
For that, make sure you are in the *Provisioned Apps* pane.
Click on the Matomo row to expand it, and select the *Stack Output* tab.

![Get the URL of your Matomo instance](assets/new-matomo/matomo-dashboard-01.png)

Get a pop-up window revealing the URL of the particular Matomo deployment.
Click the icon in the *Action* column of the *matomo_url* row, then click the blue *Copy Output!* button.
Close the pop-up window by clicking on the *Back* button.

![Reveal the application URL](assets/new-matomo/matomo-dashboard-02.png)

Using your favorite web browser, navigate to your Matomo deployment's URL.
The Matomo welcome page appears.

![The Matomo welcome page](assets/new-matomo/matomo-dashboard-03.png)

To configure your new traffic analytics service, and to learn how to use it, start with the [Matomo Help Centre](https://matomo.org/help/).

Keep in mind that while configuring Matomo, you will need pieces of information provided in the application's *Stack Output* tab.
