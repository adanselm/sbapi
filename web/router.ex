defmodule SbSso.Router do
  use Phoenix.Router

  get "/", SbSso.PageController, :index, as: :pages
  resources "/users", SbSso.UserController
  get "/sso", SbSso.SsoController, :show_login
  post "/sso", SbSso.SsoController, :do_login
  get "/logout", SbSso.SsoController, :do_logout
end
