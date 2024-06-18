# Volume types

The following volume types are available in {{brand}} for persistent block storage devices ("volumes") managed by OpenStack Cinder.

If you create a volume without specifying a volume type, then the default volume type applies.


| Volume type name               | Default          | [Encryption](../../howto/openstack/cinder/encrypted-volumes.md) | max IOPS[^iops] |
| ------------------------------ | -----            | -----                                                           | -----           |
| `cbs`                          | :material-check: | :material-close:                                                | 10000           |
| `cbs-encrypted`                | :material-close: | :material-check:                                                | 10000           |

[^iops]: The maximum IOPS specification is essentially a cap, which creates an upper bound for individual device performance under *ideal* conditions. Actual IOPS may vary based on system load and utilization. IOPS limits are only enforced in [{{brand_public}} regions](../features/public.md).

It is possible --- though somewhat involved --- to [change the type of an existing volume](../../howto/openstack/cinder/retype-volumes.md) (also known as retyping).
