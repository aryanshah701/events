# Plug that ensures a user is logged in
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.RequireLoggedIn do 
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    # Check if user is logged in
    if conn.assigns[:user] do
      conn
    else
      # Some of it from Tuck notes 0302 require_user.ex
      # Get the redirect uri before redirect the user to the login page
      redirect_uri = conn.request_path

      conn
      |> Phoenix.Controller.put_flash(:error, "Sorry you need to be logged in")
      |> Phoenix.Controller.redirect(to: EventsWeb.Router.Helpers.page_path(conn, :login, "redirect": redirect_uri))
      |> halt()
    end

  end

end