defmodule SbSso.SsoController do
  use Phoenix.Controller
  alias SbSso.Router
  alias SbSso.Repo
  alias SbSso.Queries
  alias SbSso.Users

  @my_secret "proutproutprout"
  @discourse_url "http://localhost:8080/session/sso_login?"

  def show_login(conn, params) do
    render conn, "login", params: params
  end

  def do_login(conn, params) do
    sso = create_sso(params)
    payload = URI.encode_query(sso)
              |> :base64.encode_to_string
              |> to_string
    sig = payload
          |> sign(@my_secret)
          |> String.downcase
    encoded_payload = URI.encode_www_form(payload)
    url = @discourse_url <> "sso=" <> encoded_payload <> "&sig=" <> sig
    IO.inspect(url)
    redirect conn, url
  end

  def parse(params) do
    sso = params["sso"]
    sig = String.upcase( params["sig"] )

    if sign(sso, get_secret()) !== sig do
      raise RuntimeError, message: "Bad signature for payload"
    end

    decoded = :base64.decode_to_string(sso) |> to_string
    IO.inspect(decoded)
    hquery = URI.decode_query(decoded)
  end

  defp create_sso(params) do
    Map.merge(params, %{"name" => "sam", "external_id" => "hello123", "username" => "samsam"})
  end

  defp sign(payload, sso_secret) do
    to_string( :hmac.hexlify(:hmac.hmac256(sso_secret, payload)) )
  end

  defp get_secret do
    @my_secret
  end

end
