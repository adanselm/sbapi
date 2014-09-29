defmodule SbSso.Admin.UserController do
  use Phoenix.Controller
  alias SbSso.Router
  alias SbSso.Repo
  alias SbSso.Queries
  alias SbSso.UserController

  plug :authenticate, :admin
  plug :action

  def index(conn, params) do
    users = Queries.users_query
    email = get_session(conn, :email)
    render conn, "index", users: users, email: email, params: params
  end

  def new(conn, params) do
    UserController.new(conn, params)
  end

  def show(conn, params) do
    user = Queries.user_detail_query(params["id"])
    email = get_session(conn, :email)
    render conn, "user", user: user, action: params["action"], email: email, params: params
  end

  def edit(conn, params = %{"id" => id}) do
    user = Queries.user_detail_query(id)
    email = get_session(conn, :email)
    render conn, "edit", user: user, email: email, params: params
  end

  def update(conn, params) do
    IO.inspect params["type"]
    user = Queries.user_detail_query(params["id"])
    user = %{user | email: params["email"], first_name: params["firstname"], last_name: params["lastname"]}
    Repo.update(user)
    redirect conn, Router.admin_user_path(:index, params)
  end

  def destroy(conn, params) do
    user = Queries.user_detail_query(params["id"])
    Repo.delete(user)
    redirect conn, Router.admin_user_path(:index, params)
  end

  defp authenticate(conn, :admin) do
    if get_session(conn, :email) === "adrien@springbeats.com" do
      conn
    else
      halt conn
    end
  end

end
