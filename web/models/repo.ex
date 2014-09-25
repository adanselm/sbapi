defmodule SbSso.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    c = Application.get_env(:phoenix, :sso)[:db_config]
    parse_url "ecto://#{c.db_user}:#{c.db_pwd}@#{c.db_host}:#{c.db_port}/#{c.db_name}?#{c.db_options}"
  end

  def priv do
    app_dir(:sb_sso, "priv/repo")
  end

end

