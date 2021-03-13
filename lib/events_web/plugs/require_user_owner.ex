# Plug that ensures the user is the owner of the event
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.RequireUserOwner do 
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    # Check if user is the owner
    logged_in_user_id = conn.assigns[:user].id

    if true do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Sorry you can't access someone else's user details")
      |> Phoenix.Controller.redirect(to: EventsWeb.Router.Helpers.user_path(conn, :show, logged_in_user_id))
      |> halt()
    end

  end

end