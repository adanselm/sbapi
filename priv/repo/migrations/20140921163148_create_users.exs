defmodule SbSso.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    ["CREATE TABLE users(id serial primary key, email varchar(125) unique not null, first_name varchar(50), last_name varchar(50), username varchar(50), passwd_hash varchar(64) not null, salt varchar(64) not null, creation_datetime timestamp)",
    "INSERT INTO users(email, first_name, last_name, username, passwd_hash, salt, creation_datetime) VALUES ('foo@bar.com', 'Foo', 'Bar', 'foobar', '$2a$12$B.Ye..0ygflpgXsiQ8SOCOZsAd4GJEU2SDzHgMhLg5hLhLIP2BOc2', '$2a$12$B.Ye..0ygflpgXsiQ8SOCO', current_timestamp)"
    ]
  end

  def down do
    "DROP TABLE users"
  end
end
