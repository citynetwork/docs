# Object versioning

> Object versioning requires that you configure your environment with
> [working S3-compatible credentials](credentials.md).


## Enabling bucket versioning

To enable versioning in a bucket, use one of the following commands:

=== "aws"
    ```bash
    aws --profile <region> \
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
      s3api get-bucket-versioning \
      --bucket <bucket-name>
    ```
=== "mc"
    ```bash
    mc version info <region>/<bucket-name>
    ```
=== "s3cmd"
    This functionality is not available with the `s3cmd` command.


## Creating a versioned object

Once object versioning is enabled on a bucket, the normal object
creation and replacement commands behave in a manner different from
that in unversioned buckets:

* If the object does not already exist, it is created (as in an
  unversioned bucket).
* If the object does already exist, it is not replaced. Instead, a new
  version appears in addition to the old one.

=== "aws"
    ```bash
    aws --profile <region> \
      s3api put-object \
      --bucket <bucket-name> \
      --key <object-name> \
      --body <local-filename>
    ```
=== "mc"
    ```bash
    mc cp \
      <local-filename> \
      <region>/<bucket-name>/<object-name>
    ```
=== "s3cmd"
    ```bash
    s3cmd put <local-filename> s3://<bucket>
    ```


## Listing object versions

In a bucket that has versioning enabled, you may list the versions
available for an object:

=== "aws"
    ```bash
    aws --profile <region> \
      s3api list-object-versions \
      --bucket <bucket-name> \
      --key <object-name>
    ```
=== "mc"
    ```bash
    mc stat --versions <region>/<bucket-name>
    ```
    This functionality may be impacted by bugs in several versions of
    the `mc` client.
=== "s3cmd"
    This functionality is not available with the `s3cmd` command.


## Retrieving a versioned object

To download a specific version of an object in a bucket, use one of
the following commands:

=== "aws"
    ```bash
    aws --profile <region> \
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
latest version of that object.


## Deleting a versioned object

Like the commands to *create* objects, the commands to *delete* them
behave differently once object versioning is enabled on a bucket.

The command to delete an object will normally not delete it, but
revert it to the prior version. The exception to this rule is when
there is only a single version of the object left in the bucket, in
which case object removal does occur.

=== "aws"
    ```bash
    aws --profile <region> \
      s3api delete-object \
      --bucket <bucket-name> \
      --key <object-name>
    ```
=== "mc"
    ```bash
    mc rm \
      <region>/<bucket-name>/<object-name>
    ```
=== "s3cmd"
    ```bash
    s3cmd del s3://<bucket-name>/<object-name>
    ```

You also have the option of deleting not the latest version, but a
specific object version:

=== "aws"
    ```bash
    aws --profile <region> \
      s3api delete-object \
      --version-id <versionid> \
      --bucket <bucket-name> \
      --key <object-name>
    ```
=== "mc"
    ```bash
    mc rm \
      --version-id <versionid> \
      <region>/<bucket-name>/<object-name>
    ```
=== "s3cmd"
    This functionality is not available with the `s3cmd` command.
