---
description: You can set a bucket’s lifecycle configuration such that it automatically deletes objects after a certain number of days.
---
# Object expiry

> Object expiry requires that you configure your environment with
> [working S3-compatible credentials](credentials.md).

{{page.meta.description}}

## Enabling object expiry

First, you need to create a JSON file, `lifecycle.json`, that contains
the lifecycle configuration rule. Be sure to set `Days` to your
desired value:

```json
{
  "Rules": [{
    "ID": "cleanup",
    "Status": "Enabled",
    "Prefix": "",
    "Expiration": {
        "Days": 5
    }
  }]
}
```

Then, apply this lifecycle configuration to your bucket using one of
the following commands:

=== "aws"
    ```bash
    aws --profile <region> \
      s3api put-bucket-lifecycle-configuration \
      --lifecycle-configuration file://lifecycle.json \
      --bucket <bucket-name>
    ```
=== "mc"
    ```bash
    mc ilm import <region>/<bucket-name> < lifecycle.json
    ```
=== "s3cmd"
    ```bash
    s3cmd -c ~/.s3cfg-<region> setlifecycle lifecycle.json s3://<bucket-name>
    ```

## Removing object expiry

At some point, you might want to remove the object expiry
functionality configuration from a bucket, so that objects in it no
longer auto-delete after a period.

=== "aws"
    With the `aws s3api` command, you can remove the lifecycle
    configuration from a bucket:
    ```bash
    aws --profile <region> \
      s3api delete-bucket-lifecycle \
      --bucket <bucket-name>
    ```
=== "mc"
    With `mc`, you are able to remove just an individual bucket
    lifecycle rule. Assuming your rule uses the ID `cleanup`, here is
    how you remove it:
    ```bash
    mc ilm rm --id "cleanup" <region>/<bucket-name>
    ```
=== "s3cmd"
    With `s3cmd`, you can remove the lifecycle configuration from a
    bucket:
    ```bash
    s3cmd -c ~/.s3cfg-<region> dellifecycle s3://<bucket-name>
    ```
