defmodule SbSso.Users do
  use Ecto.Model

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :passwd_hash, :string
    field :salt, :string
    field :creation_datetime, :datetime
  end
end

