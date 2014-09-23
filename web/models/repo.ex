defmodule SbSso.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url "ecto://qptfyuhwkewnvq:tVXbJtWkfjdS5g1cOz_JvKAXVJ@ec2-54-225-101-4.compute-1.amazonaws.com:5432/d38a4b277negal?ssl=true"
  end

  def priv do
    app_dir(:sb_sso, "priv/repo")
  end

end

