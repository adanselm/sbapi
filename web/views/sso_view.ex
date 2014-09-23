defmodule SbSso.SsoView do
  use SbSso.Views
  alias SbSso.SsoController

  def extract_nonce(params) do
    SsoController.parse(params)["nonce"]
  end

end
