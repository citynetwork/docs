# Volume types

The following volume types are available in {{brand}} for persistent block storage devices ("volumes") managed by OpenStack Cinder.

If you create a volume without specifying a volume type, then the default volume type applies.


| Volume type    | Default          | [Encryption](../../howto/openstack/cinder/encrypted-volumes.md) |
| -----------    | -------          | ------------                                                    |
| `cbs-standard` | :material-close: | :material-check:                                                |
| `cbs-premium`  | :material-check: | :material-check:                                                |

It is possible --- though somewhat involved --- to [change the type of an existing volume](../../howto/openstack/cinder/retype-volumes.md) (also known as retyping).

In Sto-Com, Quality of Service for Cinder is as follows:

| Volume type    | Min IOPS | IOPS / Provisioned GB | Max IOPS[^iops] | Min throughput (MBps) | Throughput / Provisioned GB (MBps) | Max throughput (MBps) |
| -----------    | -------- | --------------------- | --------------- | --------------------- | ---------------------------------- | --------------------- |
| `cbs-standard` | 500      | 50                    | 8000            | 50                    | 3                                  | 500                   |
| `cbs-premium`  | 3000     | 100                   | 16000           | 100                   | 6                                  | 1000                  |
| Local Storage  | 40000    | N/A                   | 40000           | 1000                  | N/A                                | 1000                  |

[^iops]: The maximum IOPS specification is essentially a cap, which creates an upper bound for individual device performance under *ideal* conditions. Actual IOPS may vary based on system load and utilization.
