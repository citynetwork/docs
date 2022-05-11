# Object versioning

> Object versioning requires that you configure your environment with
> [working S3-compatible credentials](credentials.md).


## Enabling bucket versioning

To enable versioning in a bucket, use one of the following commands:

=== "aws"
    ```bash
    aws --profile <region> \
      --endpoint-url=https://s3-<region>.{{extra.brand_domain}}:8080 \
      s3api put-bucket-versioning \ 
      --versioning-configuration Status=Enabled \ 
      --bucket <bucket-name>
    ```
=== "mc"
    ```bash
    mc version enable <region>/<bucket-name>
    ```
=== "s3cmd"
    This functionality is not available with the `s3cmd` command.


## Checking bucket versioning status

To check whether object versioning is enabled on a bucket, use one of
the following commands:

=== "aws"
    ```bash
    aws --profile <region> \
      --endpoint-url=https://s3-<region>.{{extra.brand_domain}}:8080 \
      s3api get-bucket-versioning \ 
      --bucket <bucket-name>
    ```
=== "mc"
    ```bash
    mc version info <region>/<bucket-name>
    ```
=== "s3cmd"
    This functionality is not available with the `s3cmd` command.


## Retrieving a versioned object

To download a specific version of an object in a bucket, use one of
the following commands:

=== "aws"
    ```bash
    aws --profile <region> \
      --endpoint-url=https://s3-<region>.{{extra.brand_domain}}:8080 \
      s3api get-object \ 
      --bucket <bucket-name> \
	  --key <object-name> \
	  --version-id <versionid> \
	  <local-filename>
    ```
=== "mc"
    ```bash
    mc cp \
	  --version-id <versionid> \
	  <region>/<bucket-name>/<object-name> \
	  <local-filename>
    ```
=== "s3cmd"
    This functionality is not available with the `s3cmd` command.

When you download an object from a versioned bucket *without*
specifying a version identifier, your S3 client will download the
latest version of the object that the bucket contains.
