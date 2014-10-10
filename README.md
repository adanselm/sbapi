# SbAPI : A user management app in Elixir/[Phoenix] that includes an SSO service

This is what I use as an SSO server for [springbeats.com](http://springbeats.com) and our discourse forum at [discuss.springbeats.com](http://discuss.springbeats.com)

Features:

* Admin panel to add/remove/update users
* Login and account creation for normal users
* Login from SSO endpoint to use with third party applications
* Passwords are secured using client and server hashing, salt, and slow hashing
* Captcha reduces the risk for account creation by robots

[Phoenix]: https://github.com/phoenixframework/phoenix

## Installation

1. Install dependencies with `mix deps.get`
2. Change configuration for your different environments in `config/*.exs` (see below)
3. Start Phoenix router with `mix phoenix.start`

Now you can visit `localhost:4000/users` from your browser.
Use `localhost:4000/sso` as the target URL for SSO from Discourse.
Create an account with the email defined as admin, and you'll have access to `/admin/users`.

## Configuration

Specific parameters of this application:

```elixir
config :phoenix, :sso,
  db_config: %{ db_user: "db_user",
                db_pwd: "db_password",
                db_host: "db_host",
                db_port: "5432",
                db_name: "database",
                db_options: "ssl=true" },
  payload_secret: "my_payload_secret_as_defined_on_client",
  redirect_url: "http://localhost:8080/session/sso_login?",
  admin_email: "admin@mydomain.com"

config :bcrypt, [mechanism: :port, pool_size: 4]

config :exrecaptcha,
  api_config: %{ verify_url: "http://www.google.com/recaptcha/api/verify",
                 public_key: "my_google_public_key",
                 private_key: "my_google_private_key" }
```

* payload_secret: a secret token that the SSO client uses to encode the conversation
* redirect_url: once the authentication succeeded via SSO, redirects to this URL with the NONCE used for the initial request
* admin_email: email of the user that'll have access to the admin section
* bcrypt stuff: I had difficulties using the nif version of bcrypt, so I went with the port version. Here you can tune the number of processes running for bcrypt.
* verify_url: Google ReCaptcha's verify url
* public_key, private_key: as given by Google on [https://www.google.com/recaptcha/admin#list](https://www.google.com/recaptcha/admin#list)

In order to use https in production, modify `config/prod.exs` as follows:

```elixir
config :phoenix, SbSso.Router,
  port: System.get_env("PORT"),
  ssl: true,
  keyfile: System.get_env("SSL_KEYFILE")",
  certfile: System.get_env("SSL_CERTFILE")",
  cacertfile: System.get_env("SSL_CACERTFILE")",
  password: System.get_env("SSL_PWD"),
  #...

```

You can then pass your environment variables at startup:

```bash
SSL_PWD=abcdef SSL_KEYFILE=/abc/d.key ... MIX_ENV=prod elixir -pa _build/prod/consolidated -S mix phoenix.start
```

## Notes

* For more information on the way SSO is implemented, please refer to [Discourse's website](https://meta.discourse.org/t/official-single-sign-on-for-discourse/13045), since it was done to comply to their protocol.
* If you choose to change the application's structure, you could manually start the router from your code like this `SbSso.Router.start`

## Todo

* Finish Flash messages handling
* Send confirmation email
* Improve user experience when filling in form with wrong data or existing username
* Create roles so that other users could become admin
* Proper user dashboard gui
* Add product api for users to handle their subscriptions

## Contribution

No policies at the moment. Send any improvement you got.

## Licensing
Copyright © 2014 [Adrien Anselme](https://github.com/adanselm) for [Springbeats.com](http://springbeats.com) and [contributors](https://github.com/adanselm/sbapi/graphs/contributors)
MIT license. See COPYING for details.

