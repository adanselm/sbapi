defmodule SbSso.CryptoHelpers do

  def sign(payload, sso_secret) do
    to_string( :hmac.hexlify(:hmac.hmac256(sso_secret, payload)) )
    |> String.downcase
  end

  def generate_salt(num_bytes) do
    :crypto.bytes_to_integer(:crypto.strong_rand_bytes(num_bytes))
  |> :erlang.integer_to_list
  end

  def generate_salt() do
    {:ok, salt} = :bcrypt.gen_salt(10)
    salt
  end

  def hash(password, salt) when password !== nil and salt !== nil do
    {:ok, h} = :bcrypt.hashpw(password, salt)
    h
  end

end
