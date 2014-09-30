defmodule SbSso.Queries do
  import Ecto.Query
  alias SbSso.Users
  alias SbSso.Repo
  alias SbSso.LoginAttempts

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
    Repo.one(query)
  end

  def user_detail_from_email_query(email) do
    s_email = to_string(email)
    query = from user in Users,
            where: user.email == ^s_email,
            select: user
    Repo.one(query)
  end

  def attempts_after_datetime_query(userid, datetime) do
    int_id = if is_integer(userid) do userid else String.to_integer(userid) end
    query = from attempt in LoginAttempts,
            where: attempt.userid == ^int_id and attempt.time > ^datetime,
            select: attempt
    Repo.all(query)
  end

end
