use Mix.Config

# NOTE: To get SSL working, you will need to set:
#
#     ssl: true,
#     keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#     certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#
# Where those two env variables point to a file on disk
# for the key and cert

config :phoenix, SbSso.Router,
  port: System.get_env("PORT"),
  ssl: false,
  host: "example.com",
  cookies: true,
  session_key: "_sb_sso_key",
  session_secret: "9L74O8B1EYC9CHQGY^^2(11T)N#0PBYM21K_1WES#O092!8L@*G)1B!P0(II4*WB8U(_71GI!&HJ+O8"

config :logger, :console,
  level: :info,
  metadata: [:request_id]

