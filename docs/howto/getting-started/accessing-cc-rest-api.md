# Accessing the Cleura Cloud REST API

{{brand}} provides a REST API, which you can take advantage of with a
tool like `curl`. But before you do, you must create a token for the
current session. For that, you only need to have an
[account in {{brand}}](create-account.md).

## Creating a token

{{rest_api}} calls use token authentication. The process of
obtaining a valid token works slightly differently, based on whether
your account has two-factor authentication (2FA) enabled or not.

=== "Without 2FA"
    If you do not have 2FA enabled for your account, to create a token,
    have your username (`your_cc_username`) and password
    (`your_cc_password`) to the {{brand}} handy and type:

    ```bash
    curl -d '{"auth": {"login": "your_cc_username", "password": "your_cc_password"}}' \
        https://{{rest_api_domain}}/auth/v1/tokens
    ```

    Provided you typed your username and password correctly and that there
    were no connection issues to the remote endpoint, you will get a JSON
    object with a string (`token`) that holds your session token:

    ```json
    {
      "result": "login_ok",
      "token": "vahkie7EiDaij7chegaitee2zohsh1oh"
    }
    ```

=== "With 2FA"

    If your {{brand}} account has 2FA enabled, you **must** configure
    it with SMS as a second-factor option. Accounts with only WebAuthn
    as their second factor cannot be used for {{rest_api}} operations.

    First, initiate a token request giving your {{brand}} username and
    password, and setting the `twofa_method` option to `sms`:

    ```bash
    curl -d '{"auth": {"login": "your_cc_username", "password": "your_cc_password", "twofa_method": "sms"}}' \
        https://{{rest_api_domain}}/auth/v1/tokens
    ```

    Instead of a token, you will get a verification code
    (look at `verification`):

    ```json
    {
      "result": "twofactor_required",
      "type": "sms",
      "verification": "ahb4en3cho"
    }
    ```

    This verification code is required for requesting a 2FA code:

    ```bash
    curl -d '{"request2fa": {"login": "your_cc_username", "verification": "ahb4en3cho"}}' \
        https://{{rest_api_domain}}/auth/v1/tokens/request2facode
    ```

    You will now receive your 6-digit second-factor code via an SMS message.
    This enables you to request your REST API token like this:

    ```bash
    curl -d '{"verify2fa": {"login": "your_cc_username", "verification": "ahb4en3cho", "code": 123456}}' \
        https://{{rest_api_domain}}/auth/v1/tokens/verify2fa
    ```

    Make sure *not* to put the code in quotes, for it is
    of type integer and that fact should be reflected during the
    assignment to `code`. You will get a JSON object with your token:

    ```json
    {
      "result": "login_ok",
      "token": "fiushood9oraTiNa4ban3eemeezoeDae"
    }
    ```

Now that you have obtained a valid token, you can proceed with making
{{rest_api}} calls.

## Testing the token

One way to make sure the token is valid is by getting a list of all
supported regions. All you have to do is use `curl` to provide your
username (`your_cc_username`) and token and connect to the
`https://{{rest_api_domain}}/accesscontrol/v1/openstack/domains`
endpoint:

```bash
curl -H "X-AUTH-LOGIN: your_cc_username" \
    -H "X-AUTH-TOKEN: vahkie7EiDaij7chegaitee2zohsh1oh" \
    https://{{rest_api_domain}}/accesscontrol/v1/openstack/domains
```

All supported regions should be returned as objects in a JSON array:

```json
[
  {
    "area": {
      "id": "6",
      "name": "Sweden \/ Stockholm",
      "tag": "SE_STO2",
      "regions": [
        {
          "zone_id": "2",
          "name": "Stockholm \/ Sweden",
          "status": "active",
          "region": "Sto2"
        }
      ]
    },
    "id": "79b0cef45b504586ad0bf057dc4cb8b8",
    "status": "provisioned",
    "name": "CCP_Domain_43597",
    "enabled": true
  },
  {
    "area": {
      "id": "7",
      "name": "Germany \/ Frankfurt",
      "tag": "DE",
      "regions": [
        {
          "zone_id": "6",
          "name": "Frankfurt \/ Germany",
          "status": "active",
          "region": "Fra1"
        }
      ]
    },
    "id": "08db589d04f442e19c272f2cd1a02906",
    "status": "provisioned",
    "name": "CCP_Domain_43597",
    "enabled": true
  },
  {
    "area": {
      "id": "1",
      "name": "Europe",
      "tag": "EU",
      "regions": [
        {
          "zone_id": "1",
          "name": "Karlskrona \/ Sweden",
          "status": "active",
          "region": "Kna1"
        }
      ]
    },
    "id": "a018123218f5428ba96d7fb212d90cf2",
    "status": "provisioned",
    "name": "CCP_Domain_43597",
    "enabled": true
  }
]
```
