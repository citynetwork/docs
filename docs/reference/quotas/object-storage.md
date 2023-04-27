---
description: Resource limits (quotas) for object storage
---
# Object storage quotas

In {{brand}}, the following limits (quotas) apply to our object storage services.
Quotas generally apply regardless of whether you are using the [S3](../../howto/object-storage/s3/index.md) or the [Swift](../../howto/object-storage/swift/index.md) API to access object storage.

| Quota name         | Value     | Notes                                                                                                                                     |
| -------------      | --------- | ---------------------                                                                                                                     |
| Objects per bucket | 1,638,400 | Maximum number of objects per bucket (S3 API) or container (Swift API)                                                                    |
| Data per bucket    | unlimited | Aggregate amount of data (total size of all objects) per bucket or container                                                              |

## Requesting a quota increase

If you find that you need to deploy more object storage data than the default quota allows, please file a support request with our [{{support}}](https://{{support_domain}}/servicedesk).
