# Why you should not attempt to delete projects

You may have noticed that the {{gui}} does not provide a mechanism
for completely wiping out projects, also known as *tenants*. In other
words, you cannot simply delete a project and **all** of its resources
in one go. Also, you cannot delete a project even after you have
meticulously deleted all of its resources.

Following is a list of facts explaining our policy **against** wiping
out or deleting projects.

## Purging a project's resources is not possible

There is simply no support for deleting all resources belonging to
a project in one fell swoop, not even at the OpenStack API level.
That is why you can also **not** wipe out projects even from the
command line.

## A way of deleting a project

Once all of its associated resources have been removed, deleting
a project is *technically* feasible. To delete a project with no
associated resources, a user with domain admin privileges may
utilize the OpenStack CLI. The `openstack` client understands the
command `project`, and that command understands the `delete`
subcommand. But to successfully run
`openstack project delete <project>`, domain admin privileges are
required, and those are **not** available for {{brand}} users.

## Disabling a project is possible

If you wish to disable a project, you can do so via the {{rest_api}}.
Make sure
[you have access](../howto/getting-started/accessing-cc-rest-api.md)
to it, and then consult the documentation to actually
[disable a project](https://apidoc.cleura.cloud/#api-AccessControl_Openstack-OSEditOpenstackProject).
