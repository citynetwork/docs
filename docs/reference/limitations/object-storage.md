# Object storage limitations

## Swift API

### Versioning

When using [object versioning](../../howto/object-storage/swift/versioning.md) with the Swift API, only the `X-Versions-Location` header is supported.
In {{brand}}, there is no support for `X-History-Location`.

### `.rlistings` ACL element

In access control lists (ACLs) set on containers via the Swift API, the `.rlistings` [ACL element](https://docs.openstack.org/swift/latest/overview_acl.html#common-acl-elements) has no effect.
In a public container (one with one or more `.r:` elements in its ACL), any client that is able to retrieve objects is also able to list them.

### Container-to-container sync

In {{brand}}, there is no support for [container-to-container synchronization](https://docs.openstack.org/swift/latest/overview_container_sync.html).

## S3 API

### Bucket replication

There is currently no support for [S3 bucket replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html) in {{brand}}.

### Bucket notifications

There is currently no support for [S3 bucket notifications](https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventNotifications.html) in {{brand}}.

### Object lock retention modes

For buckets configured with [object lock](../../howto/object-storage/s3/object-lock.md), the only supported retention mode is `COMPLIANCE`.
We do not support `GOVERNANCE` mode.

### SSE-KMS

There is currently no support for SSE-KMS in {{brand}}. SSE-C, in contrast, [is fully supported](../../howto/object-storage/s3/sse-c.md).
