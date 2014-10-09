defmodule SbSso.Mixfile do
  use Mix.Project

  def project do
    [ app: :sb_sso,
      version: "0.0.1",
      elixir: "~> 1.0.0",
      elixirc_paths: ["lib", "web"],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { SbSso, [] },
      applications: [:phoenix, :cowboy, :logger, :postgrex, :ecto,
                     :erlsha2, :bcrypt, :exrecaptcha]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:phoenix, "0.4.1"},
      {:cowboy, "~> 1.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.2.0"},
      {:erlsha2, github: "vinoski/erlsha2"},
      {:bcrypt, github: "smarkets/erlang-bcrypt"},
      {:ibrowse, github: "cmullaparthi/ibrowse"},
      {:exrecaptcha, "~> 0.0.1"}
    ]
  end
end
