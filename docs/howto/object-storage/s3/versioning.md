# Object versioning

If you are unfamiliar with object versioning, see our brief [explanation](../../../background/object-storage.md#object-versioning) of the concept.

Object versioning requires that you configure your environment with [working S3-compatible credentials](credentials.md).

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

## Suspending bucket versioning

To suspend versioning on a bucket (versioning cannot be completely
disabled once enabled), use one of the following commands:

=== "aws"
    ```bash
    aws --profile <region> \
    s3api put-bucket-versioning \
    --versioning-configuration Status=Suspended \
    --bucket <bucket-name>
    ```
=== "mc"
    ```bash
    mc version suspend <region>/<bucket-name>
    ```

## Creating a versioned object

Once object versioning is enabled on a bucket, the normal object
creation and replacement commands behave in a manner different from
that in unversioned buckets:

* If the object does not already exist, it is created (as in an unversioned bucket).
* If the object does exist, it is not replaced.
  Instead, the new version becomes the current one.

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
    s3cmd -c ~/.s3cfg-<region> put <local-filename> s3://<bucket>
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

The command to delete an object will not delete it, but
put a delete marker on it instead. This will keep all the versions
but return a "Not found" 404 on any request not specifying a valid version id.

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
    s3cmd -c ~/.s3cfg-<region> del s3://<bucket-name>/<object-name>
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

## Deleting a versioned bucket

Sometimes, you may want to delete a whole bucket that

* is versioning-enabled,
* contains lots of objects, and
* contains multiple versions of each object.

In that case, the deletion process can become quite involved.

However, you can use a shortcut via [object expiry](expiry.md):
you set a lifecycle policy that defines the minimum expiry age of 1 day, and includes both older versions and delete markers in object expiry.

A lifecycle policy applicable for this purpose would be this:

```json
{
  "Rules": [{
    "ID": "empty-bucket",
    "Status": "Enabled",
    "Prefix": "",
    "Expiration": {
      "Days": 1
    },
    "NoncurrentVersionExpiration": {
      "NoncurrentDays": 1
    }
  },
  {
    "ID": "expire-delete-markers",
    "Status": "Enabled",
    "Prefix": "",
    "Expiration": {
      "ExpiredObjectDeleteMarker": true
    },
    "NoncurrentVersionExpiration": {
      "NoncurrentDays": 1
    }
  }]
}
```

[Enable](expiry.md#enabling-object-expiry) this policy on the bucket you want to delete, and wait 24 hours.
Then, you should be able to delete the bucket, which will at that point be empty.
