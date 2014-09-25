defmodule SbSso.SsoController do
  use Phoenix.Controller
  alias SbSso.Queries
  alias SbSso.CryptoHelpers

  def show_login(conn, params) do
    render conn, "login", params: params
  end

  @doc """
  Given a map of parameters, check password and forward a signed payload
  to caller url.
  """
  def do_login(conn, params) do
    sso = authenticate(params)
    payload = URI.encode_query(sso)
              |> :base64.encode_to_string
              |> to_string
    sig = payload
          |> CryptoHelpers.sign(get_secret())
    encoded_payload = URI.encode_www_form(payload)
    url = get_url <> "sso=" <> encoded_payload <> "&sig=" <> sig
    redirect conn, url
  end

  @doc """
  Verify Payload signature and extract its content
  """
  def parse(params) do
    sso = params["sso"]
    sig = params["sig"]

    if CryptoHelpers.sign(sso, get_secret()) !== sig do
      raise RuntimeError, message: "Bad signature for payload"
    end

    decoded = :base64.decode_to_string(sso) |> to_string
    URI.decode_query(decoded)
  end

  """
  1.Retrieve user from DB
  2.Hash the (already client-hashed) password in params using salt in DB
  3.Compare this hash with the one stored in DB
  """
  defp authenticate(params) do
    user = Queries.user_detail_from_email_query(params["email"])
    expected_hash = user.passwd_hash
    actual_hash = CryptoHelpers.hash(params["clienthash"], user.salt)

    if actual_hash !== expected_hash do
      raise RuntimeError, message: "Username/password mismatch"
    end

    # fill in the profile
    name = user.first_name <> " " <> user.last_name
    Map.merge(params, %{"name" => name, "external_id" => user.id, "username" => user.username})
  end

  defp get_secret do
    Application.get_env(:phoenix, :sso)[:payload_secret]
  end

  defp get_url do
    Application.get_env(:phoenix, :sso)[:redirect_url]
  end

end
