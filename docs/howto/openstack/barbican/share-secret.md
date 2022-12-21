# Sharing secrets via ACLs

Normally, a Barbican secret is only available to the OpenStack API
user that created it. However, under some circumstances it may be
desirable to make a secret available to another user.

To do so, you will need

* the secret’s
  [URI](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier),
* the other user’s OpenStack API user ID.

> Any {{brand}} user can always retrieve their own user ID
> with the following command:
>
> ```bash
> openstack token issue -f value -c user_id
> ```

Once you have assembled this information, you can proceed with the
`openstack acl user add` command:

```bash
openstack acl user add \
  --user <user_id> \
  --operation-type read \
  https://region.{{brand_domain}}:9311/v1/secrets/<secret_id>
```

If you want to unshare the secret again, you simply use the
corresponding `openstack acl user remove` command:

```bash
openstack acl user remove \
  --user <user_id> \
  --operation-type read \
  https://region.{{brand_domain}}:9311/v1/secrets/<secret_id>
```
