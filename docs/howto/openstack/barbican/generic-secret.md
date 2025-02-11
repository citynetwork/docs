# Generic secret storage

The simplest way to use Barbican is to create and retrieve a securely
stored, generic secret.

## How to store a generic secret

It is possible to store any secret data with Barbican. The command
below will create a secret of the type `passphrase`, named `mysecret`,
which contains the passphrase `my very secret passphrase`.

```bash
openstack secret store \
  --secret-type passphrase \
  -p "my very secret passphrase" \
  -n mysecret
```

> The example output below uses {{brand}}'s `sto-com` region. In
> other regions, the secret
> [URIs](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)
> will differ.


```console
+---------------+------------------------------------------------------------------------------------------+
| Field         | Value                                                                                    |
+---------------+------------------------------------------------------------------------------------------+
| Secret href   | https://key-manager.sto-com.{{brand_domain}}/v1/secrets/6bab1703-3e6f-4f19-9380-9d5f7c8edd14 |
| Name          | mysecret                                                                                 |
| Created       | None                                                                                     |
| Status        | None                                                                                     |
| Content types | None                                                                                     |
| Algorithm     | aes                                                                                      |
| Bit length    | 256                                                                                      |
| Secret type   | passphrase                                                                               |
| Mode          | cbc                                                                                      |
| Expiration    | None                                                                                     |
+---------------+------------------------------------------------------------------------------------------+
```

Note that `passphrase` type secrets are symmetrically encrypted, using
the [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
encryption algorithm with a 256-bit key length. You can select other
bit lengths and algorithms with the `-b` and `-a` command line
options, if desired.

## How to retrieve secrets

Secrets are stored in Barbican in an encrypted format. You can see
a list of secrets created for your user with the following command:

```console
$ openstack secret list
+-------------+----------+------------+--------+---------------+-----------+------------+-------------+------+------------+
| Secret href | Name     | Created    | Status | Content types | Algorithm | Bit length | Secret type | Mode | Expiration |
+-------------+----------+------------+--------+---------------+-----------+------------+-------------+------+------------+
| https://key | mysecret | 2025-02-   | ACTIVE | {'default': ' | aes       |        256 | passphrase  | cbc  | None       |
| -manager.st |          | 12T13:08:3 |        | application/o |           |            |             |      |            |
| o-com.cleur |          | 1+00:00    |        | ctet-stream'} |           |            |             |      |            |
| a.cloud/v1/ |          |            |        |               |           |            |             |      |            |
| secrets/2ba |          |            |        |               |           |            |             |      |            |
| 2bebf-2a21- |          |            |        |               |           |            |             |      |            |
| 4e77-813b-  |          |            |        |               |           |            |             |      |            |
| 817a1d04b51 |          |            |        |               |           |            |             |      |            |
| a           |          |            |        |               |           |            |             |      |            |
| https://key | mysecret | 2025-02-   | ACTIVE | {'default': ' | aes       |        256 | passphrase  | cbc  | None       |
| -manager.st |          | 12T13:07:5 |        | application/o |           |            |             |      |            |
| o-com.cleur |          | 9+00:00    |        | ctet-stream'} |           |            |             |      |            |
| a.cloud/v1/ |          |            |        |               |           |            |             |      |            |
| secrets/6ba |          |            |        |               |           |            |             |      |            |
| b1703-3e6f- |          |            |        |               |           |            |             |      |            |
| 4f19-9380-  |          |            |        |               |           |            |             |      |            |
| 9d5f7c8edd1 |          |            |        |               |           |            |             |      |            |
| 4           |          |            |        |               |           |            |             |      |            |
+-------------+----------+------------+--------+---------------+-----------+------------+-------------+------+------------+
```

You can retrieve the decrypted secret with the `openstack secret get`
command, adding the `-p` (or `--payload`) option:

```console
$ openstack secret get -p \
  https://key-manager.sto-com.{{brand_domain}}/v1/secrets/6bab1703-3e6f-4f19-9380-9d5f7c8edd14
+---------+---------------------------+
| Field   | Value                     |
+---------+---------------------------+
| Payload | my very secret passphrase |
+---------+---------------------------+
```

> Unlike many other OpenStack services, which allow you to retrieve
> object references by name or UUID, Barbican only lets you retrieve
> secrets by their full
> [URI](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier).
> That URI must include the
> `https://key-manager.sto-com.{{brand_domain}}/v1/secrets/` prefix.
