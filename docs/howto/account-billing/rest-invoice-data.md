# Retrieving invoice data with the Cleura Cloud REST API

You may download some or all of your {{brand}} invoice data
using the {{rest_api}}.

## Prerequisites

Before retrieving any of your invoice data, you need to
[create a token](../getting-started/accessing-cc-rest-api.md)
for the current session.

## Saving invoice data

To save JSON data about all available invoices locally, submit
a {{rest_api}} request like this:

```bash
curl -H "X-AUTH-LOGIN: your_username" \
     -H "X-AUTH-TOKEN: your_token" \
     -o invoices.json \
     https://{{rest_api_domain}}/account/v1/invoices
```

A command like the above will download the data of up to 20 invoices
and save them as JSON objects into the file `invoices.json`. You may
change the number of invoices with the `limit` parameter:

```bash
curl -H "X-AUTH-LOGIN: your_username" \
     -H "X-AUTH-TOKEN: your_token" \
     -o invoices.json \
     https://{{rest_api_domain}}/account/v1/invoices?limit=2
```

That will limit the number of invoices to 2. Please note that you may
download data from up to 100 invoices.

## Sifting through invoice data

Once you have your invoice data, you may sift through it with a tool
like `jq`. For example, here is a quick way to check if all downloaded
invoices are already paid:

```console
jq '.[].status' invoices.json
"paid"
"paid"
```

To get a list with all invoice IDs, type the following:

```console
jq '.[].id' invoices.json
"164..."
"163..."
```

You may now get more information regarding a specific invoice. Find
out, for instance, when is (or was) the due date for the invoice with
ID `164...`:

```console
jq '.[] | select(.id=="164...") .dueDate' invoices.json
"2023-01-23"
```
