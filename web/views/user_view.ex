defmodule SbSso.UserView do
  use SbSso.Views
  alias Phoenix.Controller.Flash
  alias SbSso.SsoController

  def extract_nonce(params) do
    SsoController.parse(params)["nonce"]
  end

end
