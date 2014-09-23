defmodule SbSso do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    tree = [worker(SbSso.Repo, [])]

    opts = [strategy: :one_for_one, name: SbSso.Supervisor]
    Supervisor.start_link(tree, opts)
  end
end
