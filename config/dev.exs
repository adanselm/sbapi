use Mix.Config

config :phoenix, SbSso.Router,
  port: System.get_env("PORT") || 4000,
  ssl: false,
  host: "localhost",
  cookies: true,
  session_key: "_sb_sso_key",
  session_secret: "9L74O8B1EYC9CHQGY^^2(11T)N#0PBYM21K_1WES#O092!8L@*G)1B!P0(II4*WB8U(_71GI!&HJ+O8",
  debug_errors: true

config :phoenix, :code_reloader,
  enabled: true

config :logger, :console,
  level: :debug


