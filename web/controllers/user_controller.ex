defmodule SbSso.UserController do
  use Phoenix.Controller
  alias SbSso.Router
  alias SbSso.Repo
  alias SbSso.Queries
  alias SbSso.Users
  alias SbSso.CryptoHelpers

  def index(conn, _params) do
    email = get_session(conn, :email)
    render conn, "index", email: email
  end

  def new(conn, _params) do
    render conn, "new_user"
  end

  def create(conn, params) do
    previous_user = Queries.user_detail_from_email_query(params["email"])
    if previous_user !== nil do
      raise RuntimeError, message: "This user already exists."
    end

    cdate = Ecto.DateTime.from_erl(:erlang.localtime())
    salt = CryptoHelpers.generate_salt()
    pass = CryptoHelpers.hash(params["clienthash"], salt)
    user = %Users{email: params["email"], first_name: params["firstname"],
      last_name: params["lastname"], creation_datetime: cdate,
      username: params["username"], passwd_hash: to_string(pass), salt: to_string(salt)}
    new_user = Repo.insert(user)
    conn = sign_in(conn, new_user.email, new_user.id)
    redirect conn, Router.user_path(:index), email: new_user.email
  end

  def show(conn, params) do
    email = get_session(conn, :email)
    if email === nil do
      halt conn
    end
    user = Queries.user_detail_from_email_query(email)
    render conn, "user", user: user, action: params["action"]
  end

  def edit(conn, _params) do
    email = get_session(conn, :email)
    if email === nil do
      halt conn
    end
    user = Queries.user_detail_from_email_query(email)
    render conn, "edit", user: user
  end

  def update(conn, params) do
    user = Queries.user_detail_query(params["id"])
    if user.email !== get_session(conn, :email) do
      raise RuntimeError, message: "Can't update details of a different user than the one logged in"
    end
    user = %{user | email: params["email"], first_name: params["firstname"],
            last_name: params["lastname"]}
    Repo.update(user)
    redirect conn, Router.user_path(:index)
  end

  def destroy(conn, params) do
    user = Queries.user_detail_query(params["id"])
    if user.email !== get_session(conn, :email) do
      raise RuntimeError, message: "Can't delete a different user than the one logged in"
    end
    Repo.delete(user)
    redirect conn, Router.user_path(:index)
  end

  defp sign_in(conn, email, id) do
    conn = put_session(conn, :email, email)
    put_session(conn, :id, id)
  end

end
