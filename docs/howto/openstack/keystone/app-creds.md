---
description: A walk-through of creating and managing application credentials
---
# Application credentials

You can create application credentials and thus enable your applications to use them to authenticate against OpenStack Keystone.
Thanks to this type of credentials, you do not have to resort to your user credentials.
Applications can still authenticate using the application credentials ID along with a secret string, which has **nothing** to do with your user password.
That way, this sensitive piece of information does not have to be embedded in any particular application configuration.

One major security feature of application credentials is their capacity for expiration.
More often than not, application credentials are made to automatically expire after a certain date and time.
Passwords, on the other hand, persist essentially forever --- unless they are invalidated manually.

## Prerequisites

In {{brand}}, you manage application credentials with the OpenStack CLI, so make sure to [enable it](../../getting-started/enable-openstack-cli.md) for the region you are interested in.

## Creating application credentials

To create new application credentials with an expiration date, decide on a name and then use the `openstack` client like so:

```console
$ openstack application credential create --expiration '2025-04-30T12:00:00' angry_lamarr 

+--------------+-----------------------------------------------------------------------------------+
| Field        | Value                                                                             |
+--------------+-----------------------------------------------------------------------------------+
| id           | 1509b56ad7d94037acb21d1829107abf                                                  |
| name         | angry_lamarr                                                                      |
| description  | None                                                                              |
| project_id   | d42230ea21674515ab9197af89fa5192                                                  |
| roles        | swiftoperator reader heat_stack_owner creator member load-balancer_member         |
| unrestricted | False                                                                             |
| access_rules | []                                                                                |
| expires_at   | 2025-04-30T12:00:00.000000                                                        |
| secret       | oj-5YyYlK6zOaniUWjPuhnZFf0Blr2w1Z-                                                |
|              | bVLXVeBZVQPg8ViN99GXp3dS7vSLaNvxP9bPvADUA5N_btZKSG8g                              |
+--------------+-----------------------------------------------------------------------------------+
```

> The `--expiration` parameter accepts [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) strings, used for specifying date and time-related data.

In the example above, we chose the name `angry_lamarr`.
Also, a secret has been automatically generated for us.
Keep in mind that secrets are displayed only once, upon creation of the application credentials.

You may instead create a secret yourself and indicate it to the `openstack application credential create` command, like in the example below:

```console
$ PRETTY_GOOD_SECRET="$(pwgen -Bcns 24 1)"

$ openstack application credential create --expiration '2025-05-31T18:30:00' --secret $PRETTY_GOOD_SECRET elated_jones 
+--------------+---------------------------------------------------------------------------+
| Field        | Value                                                                     |
+--------------+---------------------------------------------------------------------------+
| id           | de01737d7b56432abf21bee71c8d1741                                          |
| name         | elated_jones                                                              |
| description  | None                                                                      |
| project_id   | d42230ea21674515ab9197af89fa5192                                          |
| roles        | swiftoperator reader heat_stack_owner creator member load-balancer_member |
| unrestricted | False                                                                     |
| access_rules | []                                                                        |
| expires_at   | 2025-05-31T18:30:00.000000                                                |
| secret       | mqufvnhbFJccnk4nKArPPUNs                                                  |
+--------------+---------------------------------------------------------------------------+
```

When creating new application credentials, you may optionally provide a description.
You can do that using the `--description` parameter, like in the example below:

```console
$ openstack application credential create \
    --description 'Seasonal route between GOH, YFB' \
    --expiration '2025-08-31T23:59:59' \
    -f yaml goofy_dijkstra

id: 3cf3a118d40f4cd8b28905c32e820ff6
name: goofy_dijkstra
description: Seasonal route between GOH, YFB
project_id: d42230ea21674515ab9197af89fa5192
roles: swiftoperator reader heat_stack_owner creator member load-balancer_member
unrestricted: false
access_rules: []
expires_at: '2025-08-31T23:59:59.000000'
secret: lterwee-AFU5ziE7G7kvIvfzVH22_9MMbfIS824ROaLggto8nbUUYejbAHcax7abMfZVU38f53q_x2DtpWEe6A
```

Note that we opted for a YAML-formatted output, for this format makes it very easy to select the secret and copy it.

## Listing and viewing application credentials

To list all application credentials you have created, type the following:

```console
$ openstack application credential list

+---------------+---------------+---------------+---------------+---------------+--------------+--------------+----------------+
| ID            | Name          | Description   | Project ID    | Roles         | Unrestricted | Access Rules | Expires At     |
+---------------+---------------+---------------+---------------+---------------+--------------+--------------+----------------+
| 1509b56ad7d94 | angry_lamarr  | None          | d42230ea21674 | heat_stack_ow | False        | None         | 2025-04-       |
| 037acb21d1829 |               |               | 515ab9197af89 | ner member    |              |              | 30T12:00:00.00 |
| 107abf        |               |               | fa5192        | creator       |              |              | 0000           |
|               |               |               |               | reader        |              |              |                |
|               |               |               |               | swiftoperator |              |              |                |
|               |               |               |               | load-balancer |              |              |                |
|               |               |               |               | _member       |              |              |                |
| de01737d7b564 | elated_jones  | None          | d42230ea21674 | heat_stack_ow | False        | None         | 2025-05-       |
| 32abf21bee71c |               |               | 515ab9197af89 | ner member    |              |              | 31T18:30:00.00 |
| 8d1741        |               |               | fa5192        | creator       |              |              | 0000           |
|               |               |               |               | reader        |              |              |                |
|               |               |               |               | swiftoperator |              |              |                |
|               |               |               |               | load-balancer |              |              |                |
|               |               |               |               | _member       |              |              |                |
| 3cf3a118d40f4 | goofy_dijkstr | Seasonal      | d42230ea21674 | heat_stack_ow | False        | None         | 2025-08-       |
| cd8b28905c32e | a             | route between | 515ab9197af89 | ner member    |              |              | 31T23:59:59.00 |
| 820ff6        |               | GOH, YFB      | fa5192        | creator       |              |              | 0000           |
|               |               |               |               | reader        |              |              |                |
|               |               |               |               | swiftoperator |              |              |                |
|               |               |               |               | load-balancer |              |              |                |
|               |               |               |               | _member       |              |              |                |
+---------------+---------------+---------------+---------------+---------------+--------------+--------------+----------------+
```

You may select specific columns...

```console
$ openstack application credential list -c ID -c Name -c "Expires At"

+----------------------------------+----------------+----------------------------+
| ID                               | Name           | Expires At                 |
+----------------------------------+----------------+----------------------------+
| 1509b56ad7d94037acb21d1829107abf | angry_lamarr   | 2025-04-30T12:00:00.000000 |
| de01737d7b56432abf21bee71c8d1741 | elated_jones   | 2025-05-31T18:30:00.000000 |
| 3cf3a118d40f4cd8b28905c32e820ff6 | goofy_dijkstra | 2025-08-31T23:59:59.000000 |
+----------------------------------+----------------+----------------------------+
```

...or choose a different output format, like JSON:

```console

$ openstack application credential list -f json
[
  {
    "ID": "1509b56ad7d94037acb21d1829107abf",
    "Name": "angry_lamarr",
    "Description": null,
    "Project ID": "d42230ea21674515ab9197af89fa5192",
    "Roles": "heat_stack_owner member creator reader swiftoperator load-balancer_member",
    "Unrestricted": false,
    "Access Rules": null,
    "Expires At": "2025-04-30T12:00:00.000000"
  },
  {
    "ID": "de01737d7b56432abf21bee71c8d1741",
    "Name": "elated_jones",
    "Description": null,
    "Project ID": "d42230ea21674515ab9197af89fa5192",
    "Roles": "heat_stack_owner member creator reader swiftoperator load-balancer_member",
    "Unrestricted": false,
    "Access Rules": null,
    "Expires At": "2025-05-31T18:30:00.000000"
  },
  {
    "ID": "3cf3a118d40f4cd8b28905c32e820ff6",
    "Name": "goofy_dijkstra",
    "Description": "Seasonal route between GOH, YFB",
    "Project ID": "d42230ea21674515ab9197af89fa5192",
    "Roles": "heat_stack_owner member creator reader swiftoperator load-balancer_member",
    "Unrestricted": false,
    "Access Rules": null,
    "Expires At": "2025-08-31T23:59:59.000000"
  }
]
```

You can view specific application credentials like so:

```console
$ openstack application credential show goofy_dijkstra

+--------------+---------------------------------------------------------------------------+
| Field        | Value                                                                     |
+--------------+---------------------------------------------------------------------------+
| id           | 3cf3a118d40f4cd8b28905c32e820ff6                                          |
| name         | goofy_dijkstra                                                            |
| description  | Seasonal route between GOH, YFB                                           |
| project_id   | d42230ea21674515ab9197af89fa5192                                          |
| roles        | heat_stack_owner member creator reader swiftoperator load-balancer_member |
| unrestricted | False                                                                     |
| access_rules | None                                                                      |
| expires_at   | 2025-08-31T23:59:59.000000                                                |
+--------------+---------------------------------------------------------------------------+
```

No matter how you choose to list or view application credentials, secrets are never displayed.

## Restricted vs unrestricted credentials

By default, application credentials are created as being *restricted*.
That is why, in the `openstack application credential show` output above, the `unrestricted` parameter is set to `False`.
You cannot use restricted application credentials for Heat, or for managing other application credentials or [trusts](https://docs.openstack.org/keystone/latest/user/trusts.html).
This restricted-by-default policy acts as a safeguard, so compromised application credentials cannot be used for creating other sets of application credentials.
If your application **has** to be able to perform such actions, and you accept the risks involved, you may create *unrestricted* application credentials like this:

```console
$ openstack application credential create --expiration '2025-02-15T23:59:59' modest_mccarthy --unrestricted

+--------------+----------------------------------------------------------------------------------------+
| Field        | Value                                                                                  |
+--------------+----------------------------------------------------------------------------------------+
| id           | 928fcdcd411c48478e18e64520fbd93d                                                       |
| name         | modest_mccarthy                                                                        |
| description  | None                                                                                   |
| project_id   | d42230ea21674515ab9197af89fa5192                                                       |
| roles        | swiftoperator creator reader load-balancer_member member heat_stack_owner              |
| unrestricted | True                                                                                   |
| access_rules | []                                                                                     |
| expires_at   | 2025-02-15T23:59:59.000000                                                             |
| secret       | bz_lFcx2ZVCZITLQZyOhztp7OjKGvhyM5uQt87QbuOw3uTPWQx99EJVNA3kpnKQNKcPfxaPsEVth9-DnLW7tew |
+--------------+----------------------------------------------------------------------------------------+
```

In the example output above, the `unrestricted` parameter is set to `True`.

## Using application credentials

One way to use application credentials is by instantiating certain `OS_` variables.
Then, you may work with the OpenStack CLI as you typically do.
Let us see how you can go about this, by first creating a new set of application credentials:

```console
$ PRETTY_GOOD_SECRET="$(pwgen -Bcns 32 1)"

$ openstack application credential create --expiration '2025-02-28T23:59:59' practical_swanson --secret $PRETTY_GOOD_SECRET

+--------------+---------------------------------------------------------------------------+
| Field        | Value                                                                     |
+--------------+---------------------------------------------------------------------------+
| id           | 0189ae5b2f3b42e0ae8bc6a67c0444bd                                          |
| name         | practical_swanson                                                         |
| description  | None                                                                      |
| project_id   | d42230ea21674515ab9197af89fa5192                                          |
| roles        | swiftoperator creator reader load-balancer_member member heat_stack_owner |
| unrestricted | False                                                                     |
| access_rules | []                                                                        |
| expires_at   | 2025-02-28T23:59:59.000000                                                |
| secret       | EPrdmKWFvs7qjrcUryvwcvdzNjYVRUjM                                          |
+--------------+---------------------------------------------------------------------------+

$ openstack application credential show practical_swanson

+--------------+---------------------------------------------------------------------------+
| Field        | Value                                                                     |
+--------------+---------------------------------------------------------------------------+
| id           | 0189ae5b2f3b42e0ae8bc6a67c0444bd                                          |
| name         | practical_swanson                                                         |
| description  | None                                                                      |
| project_id   | d42230ea21674515ab9197af89fa5192                                          |
| roles        | heat_stack_owner member creator reader swiftoperator load-balancer_member |
| unrestricted | False                                                                     |
| access_rules | None                                                                      |
| expires_at   | 2025-02-28T23:59:59.000000                                                |
+--------------+---------------------------------------------------------------------------+
```

You need to instantiate four `OS_` variables:

* `OS_AUTH_URL`, which, in our example, is set to `https://identity.sto-com.cleura.cloud`,
* `OS_AUTH_TYPE`, which should be set to `v3applicationcredential`,
* `OS_APPLICATION_CREDENTIAL_ID`, which should be set to the value of `id` (as displayed in the table above),
* `OS_APPLICATION_CREDENTIAL_SECRET`, which should be set to `$PRETTY_GOOD_SECRET`.

> Instead of `OS_APPLICATION_CREDENTIAL_ID`, you may instead initialize `OS_APPLICATION_CREDENTIAL_NAME` by simply setting it to the name of the application credentials.
> That way, you will not have to bother with the application credentials ID.

Create a new file named `acRC`, with the following content:

```bash
export OS_AUTH_URL=https://fra1.citycloud.com:5000
export OS_AUTH_TYPE=v3applicationcredential
export OS_APPLICATION_CREDENTIAL_ID=3e04d504d754445e8b8d503e0e7af3c5
export OS_APPLICATION_CREDENTIAL_SECRET=<value_of_PRETTY_GOOD_SECRET>
```

In your setup, replace the values of `OS_AUTH_URL`, `OS_APPLICATION_CREDENTIAL_ID`, and `OS_APPLICATION_CREDENTIAL_SECRET` accordingly.

Next, switch to a new local environment (e.g., start a new shell), where **none** of the variables in your OpenStack RC file is initialized.
There, source the `acRC` file you just created:

```console
source acRC
```

You can now use the `openstack` client as usual.
One example:

```console
$ openstack token issue -f yaml

expires: 2025-02-14T04:30:55+0000
id: gAAAAABnrh4_k8ksKfS-vG0QAJyY0SVM0biiv9dh...
project_id: d42230ea21674515ab9197af89fa5192
user_id: cc19369079c6457fb04a1c9ac1d023d1
```

## Troubleshooting application credentials usage

Having created a fresh set of application credentials to use with OpenStack CLI, you may find out that the `openstack` client starts behaving like its privileges are suddenly limited.
Any command you might try will fail, returning an error like in the following example:

```console
$ openstack token issue

Error authenticating with application credential: Application credentials cannot request a scope. (HTTP 401) (Request-ID: req-d59edba0-2cb5-450b-83c7-f094bd8e5654)
```

This happens because either of the `OS_PROJECT_NAME` or `OS_TENANT_NAME` variables is initialized, causing the `openstack` client to request a project scope for your token --- and that is not allowed.

This is why we advised making sure no pre-existing `OS_` variable is set *before* initializing the four `OS_` variables `openstack` needs, in order to use your application credentials.

You might want to add this function to your `.bashrc`:

```bash
function unset_os_vars() {
    unset -v `env | grep -o "^OS_[^=]*"`
}
```

From then on, you can unset all `OS_` variables by simply typing `unset_os_vars`.

## Deleting application credentials

If there are application credentials you suspect are compromised or simply do not need anymore, you may go ahead and delete them by specifying the corresponding ID or name, like so:

```console
$ openstack application credential delete goofy_dijkstra
$ openstack application credential show goofy_dijkstra

'NoneType' object is not subscriptable
```

Even though expired application credentials can no longer be used for authentication, they stay around until you explicitly delete them.

