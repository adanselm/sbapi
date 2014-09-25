defmodule SbSso.LoginAttempts do
  use Ecto.Model

  schema "login_attempts" do
    field :userid, :integer
    field :time, :datetime
  end
end

