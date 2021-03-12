# Plug that ensures that the user is the owner or invite of the event
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.RequireOwnerInvite do 
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    # Check if user is the owner or an invite
    event = conn.assigns[:event]
    logged_in_user = conn.assigns[:user]

    logged_in_user_id = logged_in_user.id
    owner_user_id = event.user_id
    invites = Enum.filter(event.invites, 
      fn invite -> invite.user_email == logged_in_user.email end)

    if logged_in_user_id == owner_user_id || Enum.count(invites) == 1 do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Sorry you aren't the owner or invite of the event!")
      |> Phoenix.Controller.redirect(to: EventsWeb.Router.Helpers.user_path(conn, :show, logged_in_user))
      |> halt()
    end

  end

end