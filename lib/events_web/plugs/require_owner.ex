# Plug that ensures the user is the owner of the event
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.RequireOwner do 
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    # Check if user is the owner
    logged_in_user_id = conn.assigns[:user].id
    owner_user_id = conn.assigns[:event].user_id

    if logged_in_user_id == owner_user_id do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Sorry you aren't the owner of the event!")
      |> Phoenix.Controller.redirect(to: EventsWeb.Router.Helpers.page_path(conn, :index))
      |> halt()
    end

  end

end