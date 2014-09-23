defmodule SbSso.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    ["CREATE TABLE users(id serial primary key, email varchar(125), first_name varchar(50), last_name varchar(50), passwd_hash bytea, creation_datetime timestamp)",
    "INSERT INTO users(email, first_name, last_name, creation_datetime) VALUES ('foo@bar.com', 'Foo', 'Bar', current_timestamp)"
    ]
  end

  def down do
    "DROP TABLE users"
  end
end
