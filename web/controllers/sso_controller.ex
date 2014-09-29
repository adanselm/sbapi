defmodule SbSso.SsoController do
  use Phoenix.Controller
  alias SbSso.Queries
  alias SbSso.CryptoHelpers
  alias SbSso.Repo
  alias SbSso.LoginAttempts
  alias SbSso.Router

  def show_login(conn, params) do
    render conn, "login", params: params, action: "login"
  end

  @doc """
  Given a map of parameters, check password and forward a signed payload
  to caller url.
  """
  def do_login(conn, params) do
    sso = authenticate(params)
    conn = put_session(conn, :email, sso["email"])
    login_response(conn, params, sso)
  end

  @doc """
  """
  def do_logout(conn, params) do
    conn = put_session(conn, :email, nil)
    redirect conn, Router.user_path(:index, params)
  end


  @doc """
  Verify Payload signature and extract its content
  """
  def parse(%{"sso" => sso, "sig" => sig}) do

    if CryptoHelpers.sign(sso, get_secret()) !== sig do
      raise RuntimeError, message: "Bad signature for payload"
    end

    decoded = :base64.decode_to_string(sso) |> to_string
    URI.decode_query(decoded)
  end

  def parse(_) do
    nil
  end

  """
  1.Retrieve user from DB
  2.Hash the (already client-hashed) password in params using salt in DB
  3.Compare this hash with the one stored in DB
  """
  defp authenticate(params) do
    user = Queries.user_detail_from_email_query(params["email"])
    if user === nil do
      raise RuntimeError, message: "Username/password mismatch"
    end

    if check_brute(user.id) do
      raise RuntimeError, message: "Too many login attempts. Retry in 2 hours."
    end

    expected_hash = user.passwd_hash
    actual_hash = to_string(CryptoHelpers.hash(params["clienthash"], user.salt))

    if actual_hash !== expected_hash do
      insert_login_attempt(user)
      raise RuntimeError, message: "Username/password mismatch"
    end

    # fill in the profile
    name = user.first_name <> " " <> user.last_name
    Map.merge(params, %{"name" => name, "external_id" => user.id, "username" => user.username})
  end

  defp check_brute(userid) do
    cur_ts_in_sec = :erlang.localtime() |> :calendar.datetime_to_gregorian_seconds
    ts_minus_2_hours = cur_ts_in_sec - (2 * 60 * 60)
    ref_ts = :calendar.gregorian_seconds_to_datetime(ts_minus_2_hours)
              |> Ecto.DateTime.from_erl
    attempts = Queries.attempts_after_datetime_query(userid, ref_ts)
    if length(attempts) > 5 do
      true
    else
      false
    end
  end

  defp insert_login_attempt(user) do
    datetime = Ecto.DateTime.from_erl(:erlang.localtime())
    attempt = %LoginAttempts{:userid => user.id, :time => datetime}
    Repo.insert(attempt)
  end

  defp login_response(conn, %{"nonce" => nonce}, sso) when is_bitstring(nonce) and byte_size(nonce) !== 0 do
    payload = URI.encode_query(sso)
              |> :base64.encode_to_string
              |> to_string
    sig = payload
          |> CryptoHelpers.sign(get_secret())
    encoded_payload = URI.encode_www_form(payload)
    url = get_url <> "sso=" <> encoded_payload <> "&sig=" <> sig
    redirect conn, url
  end
  defp login_response(conn, params, _sso) do
    redirect conn, Router.user_path(:index, params)
  end

  defp get_secret do
    Application.get_env(:phoenix, :sso)[:payload_secret]
  end

  defp get_url do
    Application.get_env(:phoenix, :sso)[:redirect_url]
  end

end
