# Object storage limitations

## Swift API

### Versioning

When using [object versioning](../../howto/object-storage/swift/versioning.md) with the Swift API, only the `X-Versions-Location` header is supported.
In {{brand}}, there is no support for `X-History-Location`.

### Container-to-container sync

In {{brand}}, there is no support for [container-to-container synchronization](https://docs.openstack.org/swift/latest/overview_container_sync.html).

## S3 API

### Bucket replication

There is currently no support for [S3 bucket replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html) in {{brand}}.

### Bucket notifications

There is currently no support for [S3 bucket notifications](https://docs.aws.amazon.com/AmazonS3/latest/userguide/NotificationHowTo.html) in {{brand}}.

### Object lock retention modes

For buckets configured with [object lock](../../howto/object-storage/s3/object-lock.md), the only supported retention mode is `COMPLIANCE`.
We do not support `GOVERNANCE` mode.

### SSE-KMS

There is currently no support for SSE-KMS in {{brand}}. SSE-C, in contrast, [is fully supported](../../howto/object-storage/s3/sse-c.md).
