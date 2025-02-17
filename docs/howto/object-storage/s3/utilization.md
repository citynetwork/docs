---
description: A number of options exist to show object storage utilization.
---
# Object storage utilization

You may be interested in the number of objects, or their cumulative size, currently held in a bucket.


## Prerequisites

To show the number or cumulative size of objects in a bucket, you must install `aws`, `mc`, or `s3cmd`, and [configure it with working credentials](credentials.md).


## Showing the number of objects in a bucket

To show the number of objects in a given bucket, use one of the following commands:

=== "aws"
    ```bash
    aws --profile <region> \
      s3 ls \
      --recursive \
      --summarize \
      s3://<bucket>
    ```
    The object count is in the line prefixed with `Total Objects`, at the end of the output.
=== "mc"
    ```bash
    mc ls <region>/<bucket> \
      --recursive \
      --summarize
    ```
    The object count is in the line prefixed with `Total Objects`, at the end of the output.

    Alternatively, you may also use the `du` subcommand:
    ```bash
    mc du <region>/<bucket>
    ```
    Here, the object count is the second column of the output.
=== "s3cmd"
    ```bash
    s3cmd -c ~/.s3cfg-<region> \
      du \
      s3://<bucket>
    ```
    The object count is the second column of the output.

## Showing the total size of objects in a bucket

To show the overall size of all objects in a given bucket, use one of the following commands:

=== "aws"
    You use the same command as for counting objects:
    ```bash
    aws --profile <region> \
      s3 ls \
      --recursive \
      --summarize \
      s3://<bucket>
    ```
    The total object size is in the line prefixed with `Total Size`, at the end of the output.

    By default, the total size is given in bytes.
    If you prefer more sensible units, add the `--human-readable` option:
    ```bash
    aws --profile <region> \
      s3 ls \
      --recursive \
      --summarize \
      --human-readable \
      s3://<bucket>
    ```
=== "mc"
    You could use the same command as for counting objects:
    ```bash
    mc ls <region>/<bucket> \
      --recursive \
      --summarize
    ```
    The total object size is in the line prefixed with `Total Size`, at the end of the output.
    It is shown in KiB, MiB, GiB, or TiB, and the value shown may thus be approximate.

    Alternatively, you may also use the `du` subcommand:
    ```bash
    mc du <region>/<bucket>
    ```
    The total object size is the first column of the output.
=== "s3cmd"
    ```bash
    s3cmd -c ~/.s3cfg-<region> \
      du \
      s3://<bucket>
    ```
    The total object size is the first column of the output.
