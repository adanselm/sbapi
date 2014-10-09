defmodule SbSso.UserController do
  use Phoenix.Controller
  alias SbSso.Router
  alias SbSso.Repo
  alias SbSso.Queries
  alias SbSso.Users
  alias SbSso.CryptoHelpers
  alias SbSso.SsoController

  def index(conn, params) do
    email = get_session(conn, :email)
    render conn, "index", email: email, params: params
  end

  def new(conn, params) do
    render conn, "new_user", params: params
  end

  def create(conn, params) do
    previous_user = Queries.user_detail_from_email_query(params["email"])
    if previous_user !== nil do
      raise RuntimeError, message: "This user already exists."
    end

    :ok = verify_captcha(conn, params)
    cdate = Ecto.DateTime.from_erl(:erlang.localtime())
    salt = CryptoHelpers.generate_salt()
    pass = CryptoHelpers.hash(params["clienthash"], salt)
    user = %Users{email: params["email"], first_name: params["firstname"],
      last_name: params["lastname"], creation_datetime: cdate,
      username: params["username"], passwd_hash: to_string(pass), salt: to_string(salt)}
    new_user = Repo.insert(user)
    conn = sign_in(conn, new_user.email, new_user.id)
    after_create(conn, params, new_user)
  end

  def show(conn, params) do
    email = get_session(conn, :email)
    if email === nil do
      halt conn
    end
    user = Queries.user_detail_from_email_query(email)
    render conn, "user", user: user, action: params["action"], params: params
  end

  def edit(conn, params) do
    email = get_session(conn, :email)
    if email === nil do
      halt conn
    end
    user = Queries.user_detail_from_email_query(email)
    render conn, "edit", user: user, params: params
  end

  def update(conn, params) do
    user = Queries.user_detail_query(params["id"])
    if user.email !== get_session(conn, :email) do
      raise RuntimeError, message: "Can't update details of a different user than the one logged in"
    end
    user = %{user | email: params["email"], first_name: params["firstname"],
            last_name: params["lastname"]}
    Repo.update(user)
    redirect conn, Router.user_path(:index, params)
  end

  def destroy(conn, params) do
    user = Queries.user_detail_query(params["id"])
    if user.email !== get_session(conn, :email) do
      raise RuntimeError, message: "Can't delete a different user than the one logged in"
    end
    Repo.delete(user)
    redirect conn, Router.user_path(:index, params)
  end

  defp sign_in(conn, email, id) do
    conn = put_session(conn, :email, email)
    put_session(conn, :id, id)
  end

  defp after_create(conn, params = %{"nonce" => nonce}, _user) when byte_size(nonce) > 0 do
    SsoController.do_login(conn, params)
  end
  defp after_create(conn, params, user) do
    render conn, "index", email: user.email, params: params
  end

  defp verify_captcha(conn, %{"recaptcha_challenge_field" => challenge,
                              "recaptcha_response_field" => response}) do
    remote_ip = conn.remote_ip
    Exrecaptcha.verify(remote_ip, challenge, response)
  end

end
