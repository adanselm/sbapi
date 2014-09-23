defmodule SbSso.Queries do
  import Ecto.Query
  alias SbSso.Users
  alias SbSso.Repo

  def users_query do
    query = from users in Users,
            order_by: [desc: users.id],
            select: users
    Repo.all(query)
  end

  def user_detail_query(id) do
    int_id = String.to_integer(id)
    query = from user in Users,
            where: user.id == ^int_id,
            select: user
    Repo.all(query) |> List.first
  end
end
