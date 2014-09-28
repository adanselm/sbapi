defmodule SbSso.Router do
  use Phoenix.Router

  scope alias: SbSso do
    get "/", PageController, :index, as: :pages
    resources "/users", UserController
    get "/sso", SsoController, :show_login
    post "/sso", SsoController, :do_login
    get "/logout", SsoController, :do_logout
  end

  scope path: "/admin", alias: SbSso.Admin, helper: "admin" do
    resources "/users", UserController
  end

end
