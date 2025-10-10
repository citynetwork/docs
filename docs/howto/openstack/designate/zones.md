---
description: A walk-through of managing DNS zones with Designate
---
# Managing zones

OpenStack Designate is a DNS-as-a-Service solution that lets you define DNS zones, add [recordsets](recordsets.md), or perform zone transfers between regions.

For the rest of this guide and all others regarding Designate, we assume you are the owner of the `example.com` domain, and you are administering its corresponding DNS zone.

## Listing available zones

To list all available zones, type the following:

```console
$ openstack zone list

```

If this is the first time you use Designate in the current tenant, the command above will return an empty line.

## Creating a new zone

To create a new zone for the `example.com` domain, use `openstack zone create` like so:

```console
$ openstack zone create --email admin@example.com example.com.
+----------------+--------------------------------------+
| Field          | Value                                |
+----------------+--------------------------------------+
| action         | CREATE                               |
| attributes     |                                      |
| created_at     | 2025-08-18T13:46:35.000000           |
| description    | None                                 |
| email          | admin@example.com                    |
| id             | 1e76fc59-4b2c-4782-a852-d4f5bcc460d8 |
| masters        |                                      |
| name           | example.com.                         |
| pool_id        | 794ccc2c-d751-44fe-b57f-8894c9f5c842 |
| project_id     | e2548c8b1a474b988027ea93bfc9248c     |
| serial         | 1755524795                           |
| shared         | False                                |
| status         | PENDING                              |
| transferred_at | None                                 |
| ttl            | 3600                                 |
| type           | PRIMARY                              |
| updated_at     | None                                 |
| version        | 1                                    |
+----------------+--------------------------------------+
```

Notice the dot (`.`) at the end of the domain name: according to the DNS standard, its presence is mandatory.

Other than that, you will see that the `status` of the new zone is `PENDING`.
This is expected, and if you ask for detailed information regarding the newly created zone a few seconds later, you will realize that its `status` has switched to `ACTIVE`:

```console
$ openstack zone show example.com.
+----------------+--------------------------------------+
| Field          | Value                                |
+----------------+--------------------------------------+
| action         | NONE                                 |
| attributes     |                                      |
| created_at     | 2025-08-18T13:46:35.000000           |
| description    | None                                 |
| email          | admin@example.com                    |
| id             | 1e76fc59-4b2c-4782-a852-d4f5bcc460d8 |
| masters        |                                      |
| name           | example.com.                         |
| pool_id        | 794ccc2c-d751-44fe-b57f-8894c9f5c842 |
| project_id     | e2548c8b1a474b988027ea93bfc9248c     |
| serial         | 1755524795                           |
| shared         | False                                |
| status         | ACTIVE                               |
| transferred_at | None                                 |
| ttl            | 3600                                 |
| type           | PRIMARY                              |
| updated_at     | 2025-08-18T13:46:41.000000           |
| version        | 2                                    |
+----------------+--------------------------------------+
```

Since you added a new zone, try the `openstack zone list` command once more:

```console
$ openstack zone list
+--------------------------------------+-------------------+---------+------------+--------+--------+
| id                                   | name              | type    |     serial | status | action |
+--------------------------------------+-------------------+---------+------------+--------+--------+
| 1e76fc59-4b2c-4782-a852-d4f5bcc460d8 | example.com.      | PRIMARY | 1755524795 | ACTIVE | NONE   |
+--------------------------------------+-------------------+---------+------------+--------+--------+
```

This time, the command returns non-empty output, and you get what you expected: information regarding the one zone you just defined.

Optionally, you may add a description to the new domain:

```console
$ openstack zone set --description "Pseudorandom Pufferfish" example.com.
+----------------+--------------------------------------+
| Field          | Value                                |
+----------------+--------------------------------------+
| action         | UPDATE                               |
| attributes     |                                      |
| created_at     | 2025-08-18T13:46:35.000000           |
| description    | Pseudorandom Pufferfish              |
| email          | admin@example.com                    |
| id             | 1e76fc59-4b2c-4782-a852-d4f5bcc460d8 |
| masters        |                                      |
| name           | example.com.                         |
| pool_id        | 794ccc2c-d751-44fe-b57f-8894c9f5c842 |
| project_id     | e2548c8b1a474b988027ea93bfc9248c     |
| serial         | 1755525214                           |
| shared         | False                                |
| status         | PENDING                              |
| transferred_at | None                                 |
| ttl            | 3600                                 |
| type           | PRIMARY                              |
| updated_at     | 2025-08-18T13:55:40.000000           |
| version        | 5                                    |
+----------------+--------------------------------------+
```

Having defined a new zone, you can now add [recordsets](recordsets.md).

## Deleting a zone

To delete a zone, you may use the `openstack zone delete` command with the name (or UUID) of the zone.
If, for instance, you wish to delete the `example.com.` zone, type the following:

```console
$ openstack zone delete example.com.
+----------------+--------------------------------------+
| Field          | Value                                |
+----------------+--------------------------------------+
| action         | DELETE                               |
| attributes     |                                      |
| created_at     | 2025-08-18T13:46:35.000000           |
| description    | Pseudorandom Pufferfish              |
| email          | admin@example.com                    |
| id             | 1e76fc59-4b2c-4782-a852-d4f5bcc460d8 |
| masters        |                                      |
| name           | example.com.                         |
| pool_id        | 794ccc2c-d751-44fe-b57f-8894c9f5c842 |
| project_id     | e2548c8b1a474b988027ea93bfc9248c     |
| serial         | 1755618559                           |
| shared         | False                                |
| status         | PENDING                              |
| transferred_at | None                                 |
| ttl            | 3600                                 |
| type           | PRIMARY                              |
| updated_at     | 2025-08-19T15:54:29.000000           |
| version        | 13                                   |
+----------------+--------------------------------------+
```
