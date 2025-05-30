# Object versioning

> Object versioning requires that you configure your environment with
> [working S3-compatible credentials](credentials.md).

## What is object versioning ?

In default buckets objects has just one representation and all operations like removal or upload will operate on this one entity.
With versioned bucket modifications like uploading object under the same name or removal will just operate markers and modify a view of bucket.
In this bucket operation mode each object receives a unique version ID assigned and all the operations like delete, overwrite will retain old version.
This old version can be restored if needed.

Comparison table:

| Operation                    | Default bucket               | Versioned bucket                      |
| ---------------------------- | ---------------------------- | ------------------------------------- |
| Uploading a new object       | New object is stored         | New object is stored                  |
| Overwrite of existing object | New object overwrite old one | New object version becomes current    |
| Delete object                | Object is deleted            | Delete marker is placed, 404 returned |

Once you enable versioning on a bucket, it cannot be turned off - only suspended.
A versioned bucket can be in one of three states: unversioned (default), enabled, or suspended.
When versioning is suspended, new objects are created with a version ID of "null" and will overwrite any existing null version, but all previously versioned objects remain unchanged and accessible.

### Delete markers

When you delete an object in a versioned bucket, the object isn't actually removed.
Instead, object service creates a special placeholder called a delete marker that acts as the current version of the object.
This delete marker has its own unique version ID and causes object service to return a 404 "Not found" error when you try to retrieve the object normally.
However, all previous versions remain intact and accessible if you specify their version IDs.
Delete markers themselves can be deleted - when you delete a delete marker, the previous version becomes current again, effectively "undeleting" the object.
To permanently remove an object version, you must delete it by specifying its version ID.

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

* If the object does not already exist, it is created (as in an
  unversioned bucket).
* If the object does already exist, it is not replaced. Instead, a new version becomes
  the current version in addition to the old one.

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

The command to delete an object will not delete it, but
put a delete marker on it instead. This will keep all the versions
but replay "Not found" 404 on a request without specified valid version id.

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
