# Plug that ensures that the user is the owner of the comment
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.RequireCommentOwner do 
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    # Check if user is the owner or an invite
    logged_in_user_id = conn.assigns[:user].id
    comment_user_id = conn.assigns[:comment].user_id

    if logged_in_user_id == comment_user_id do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Sorry that's not your comment")
      |> Phoenix.Controller.redirect(to: EventsWeb.Router.Helpers.page_path(conn, :index))
      |> halt()
    end

  end

end