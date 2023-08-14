# Object expiry

Using the Swift API, you have the option for objects to automatically
be deleted, after they have passed an expiry threshold.


## Prerequisites

In order to manage object expiry, be sure that you have [installed and
configured](index.md) the `swift` command-line interface (CLI). There is
presently no way to set object expiry with the `openstack` CLI.


## Auto-deletion at a fixed date

In order for an object to be automatically deleted at a certain date,
you must first convert that date to a POSIX timestamp. You may do so
with the `date` command. For example, to retrieve the POSIX timestamp
for February 29, 2024, at 0000 UTC, use this command:

```console
$ TZ=Etc/UTC date -d '2024-02-29' +'%s'
1709164800
```

You can then set the `X-Delete-At` header on an object, so that it is
automatically deleted at that time:

```console
$ swift post -H "X-Delete-At: 1709164800" private-container testobj.txt

```

Then, you can read back the header with `swift stat`:

```console
$ swift stat private-container testobj.txt
               Account: AUTH_30a7768a0ffc40359d6110f21a6e7d88
             Container: private-container
                Object: testobj.txt
          Content Type: binary/octet-stream
        Content Length: 12
         Last Modified: Mon, 05 Dec 2022 14:09:02 GMT
                  ETag: 6f5902ac237024bdd0c176cb93063dc4
         Accept-Ranges: bytes
           X-Timestamp: 1670249342.53870
           X-Delete-At: 1709164800
            X-Trans-Id: tx00000646596cd018a2d7b-00638dfb91-300de11-default
X-Openstack-Request-Id: tx00000646596cd018a2d7b-00638dfb91-300de11-default
```


## Auto-deletion after a time period

Instead of giving an absolute time with `X-Delete-At`, you can also
use `X-Delete-After` (in seconds), so that the object is automatically
deleted after that timespan. This example uses 600 seconds or
10 minutes:

```console
$ swift post -H "X-Delete-After: 600" private-container testobj.txt

```

The Swift API then converts this into an `X-Delete-At` header, adding
the specified time span to the date the request is received (indicated
by the `X-Timestamp` header).

You can then read back the object metadata. Observe that in this
example, the difference between the `X-Timestamp` and `X-Delete-At`
headers is 600 seconds:

```console
$ swift stat private-container testobj.txt
               Account: AUTH_30a7768a0ffc40359d6110f21a6e7d88
             Container: private-container
                Object: testobj.txt
          Content Type: binary/octet-stream
        Content Length: 12
         Last Modified: Mon, 05 Dec 2022 14:09:55 GMT
                  ETag: 6f5902ac237024bdd0c176cb93063dc4
         Accept-Ranges: bytes
           X-Timestamp: 1670249395.20576
           X-Delete-At: 1670249995
            X-Trans-Id: tx0000065937c08551ba2be-00638dfbb6-301ddeb-default
X-Openstack-Request-Id: tx0000065937c08551ba2be-00638dfbb6-301ddeb-default
```
