# Plug that ensures that the user is either the owner of the event or comment
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.RequireSomeOwner do 
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    # Check if current user is the owner of the event or the comment 
    logged_in_user_id = conn.assigns[:user].id
    event = conn.assigns[:event]
    owner_user_id = event.user_id
    comment_owner_user_id = conn.assigns[:comment].user_id

    if logged_in_user_id == owner_user_id || 
      logged_in_user_id == comment_owner_user_id  do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Sorry you can't delete this comment")
      |> Phoenix.Controller.redirect(to: 
        EventsWeb.Router.Helpers.event_path(conn, :show, event))
      |> halt()
    end

  end

end