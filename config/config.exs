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
  session_secret: "9L74O8B1EYC9CHQGY^^2(11T)N#0PBYM21K_1WES#O092!8L@*G)1B!P0(II4*WB8U(_71GI!&HJ+O8",
  catch_errors: true,
  debug_errors: false,
  error_controller: SbSso.PageController

config :phoenix, :sso,
  payload_secret: "proutproutprout",
  redirect_url: "http://localhost:8080/session/sso_login?"

config :phoenix, :code_reloader,
  enabled: false

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bcrypt, [mechanism: :port, pool_size: 4]

# Import environment specific config. Note, this must remain at the bottom of
# this file to properly merge your previous config entries.
import_config "#{Mix.env}.exs"
