# Plug that ensures a user is not logged in for registeration purposes
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.RequireNotLoggedIn do 
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    # Check if user is logged in
    if conn.assigns[:user] do
      conn 
      |> Phoenix.Controller.put_flash(:error, "Sorry you can't be logged in to do that")
      |> Phoenix.Controller.redirect(to: EventsWeb.Router.Helpers.user_path(conn, :show, conn.assigns[:user]))
      |> halt()
    else 
      conn
    end

  end

end