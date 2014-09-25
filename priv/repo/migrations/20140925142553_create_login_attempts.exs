defmodule SbSso.Repo.Migrations.CreateLoginAttempts do
  use Ecto.Migration

  def up do
    ["CREATE TABLE login_attempts(id serial primary key, userid integer not null, time timestamp not null)"
    ]
  end

  def down do
    "DROP TABLE login_attempts"
  end
end
