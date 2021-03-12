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
      # Get the event in order to redirect back this event

      conn
      |> Phoenix.Controller.put_flash(:error, "Sorry you need to be logged in")
      |> Phoenix.Controller.redirect(to: EventsWeb.Router.Helpers.page_path(conn, :login))
      |> halt()
    end

  end

end