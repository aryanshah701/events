# Plug that adds the current logged in user onto the connection
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.AddUser do 
  import Plug.Conn

  alias Events.Users

  def init(default), do: default

  def call(conn, _default) do
    # Get the current session user_id if user is logged in
    user_id = get_session(conn, :user_id)

    # If the user is logged in add current user, else nil
    if user_id do
      # Create a token for the user
      token = Phoenix.Token.sign(conn, "user_id", user_id)

      # Get the user from the id
      user = Users.get_user(user_id)

      # Add token and user to the conn
      conn
      |> assign(:user, user)
      |> assign(:user_token, token)
    else
      assign(conn, :user, nil)
    end

  end

end