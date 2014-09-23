defmodule SbSso.UserController do
  use Phoenix.Controller
  alias SbSso.Router
  alias SbSso.Repo
  alias SbSso.Queries
  alias SbSso.Users

  def index(conn, _params) do
    users = Queries.users_query
    render conn, "index", users: users
  end

  def new(conn, _params) do
    render conn, "new_user"
  end

  def create(conn, params) do
    cdate = Ecto.DateTime.from_erl(:erlang.localtime())
    user = %Users{email: params["email"], first_name: params["firstname"], last_name: params["lastname"], creation_datetime: cdate }
    Repo.insert(user)
    redirect conn, Router.user_path(:index)
  end

  def show(conn, params) do
    user = Queries.user_detail_query(params["id"])
    render conn, "user", user: user, action: params["action"]
  end

  def edit(conn, %{"id" => id}) do
    user = Queries.user_detail_query(id)
    render conn, "edit", user: user
  end

  def update(conn, params) do
    IO.inspect params["type"]
    user = Queries.user_detail_query(params["id"])
    user = %{user | email: params["email"], first_name: params["firstname"], last_name: params["lastname"]}
    Repo.update(user)
    redirect conn, Router.user_path(:index)
  end

  def destroy(conn, params) do
    user = Queries.user_detail_query(params["id"])
    Repo.delete(user)
    redirect conn, Router.user_path(:index)
  end

end
