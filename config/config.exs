# This file is responsible for configuring your application
use Mix.Config

# Note this file is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project.

config :phoenix, SbSso.Router,
  port: System.get_env("PORT"),
  ssl: false,
  static_assets: true,
  cookies: true,
  session_key: "_sb_sso_key",
  session_secret: "a_session_secret_generated_by_mix_when_creating_phoenix_project",
  catch_errors: true,
  debug_errors: false,
  error_controller: SbSso.PageController

config :phoenix, :sso,
  db_config: %{ db_user: "db_user",
                db_pwd: "db_password",
                db_host: "db_host",
                db_port: "5432",
                db_name: "database",
                db_options: "ssl=true" },
  payload_secret: "my_payload_secret_as_defined_on_client",
  redirect_url: "http://localhost:8080/session/sso_login?",
  admin_email: "adrien@springbeats.com"

config :phoenix, :code_reloader,
  enabled: false

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bcrypt, [mechanism: :port, pool_size: 4]

config :exrecaptcha,
  api_config: %{ verify_url: "http://www.google.com/recaptcha/api/verify",
                 public_key: "my_google_public_key",
                 private_key: "my_google_private_key" }



# Import environment specific config. Note, this must remain at the bottom of
# this file to properly merge your previous config entries.
import_config "#{Mix.env}.exs"
