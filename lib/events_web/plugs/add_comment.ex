# Plug that adds the current comment onto the connection
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.AddEvent do 
  import Plug.Conn

  alias Events.Comments

  def init(default), do: default

  def call(conn, _default) do
    # Get the current event's id
    comment_id = conn.params["id"]

    # If the comment id exists, add it onto the connection
    if comment_id do
      comment = Comments.get_comment!(comment_id)
      assign(conn, :comment, comment)
    else
      assign(conn, :comment, nil)
    end

  end

end