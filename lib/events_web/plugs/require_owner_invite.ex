# Plug that ensures that the user is the owner or invite of the event
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.RequireOwnerInvite do 
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    # Check if user is the owner or an invite
    logged_in_user_id = conn.assigns[:user].id
    owner_user_id = conn.assigns[:event].user_id

    if logged_in_user_id == owner_user_id do
      conn
    else
      IO.puts logged_in_user_id
      IO.puts owner_user_id
      conn
      |> Phoenix.Controller.put_flash(:error, "Sorry you aren't the owner or invite of the event!")
      |> Phoenix.Controller.redirect(to: EventsWeb.Router.Helpers.page_path(conn, :index))
      |> halt()
    end

  end

end