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
      # From Tuck notes 0302 require_user.ex
      conn
      |> Phoenix.Controller.put_flash(:error, "Sorry you need to be logged in")
      |> Phoenix.Controller.redirect(to: EventsWeb.Router.Helpers.page_path(conn, :index))
      |> halt()
    end

  end

end