# Plug that adds the user onto the conn if the user is authorized
# Implemented using Tuck notes from 0309 require_auth.ex
defmodule EventsWeb.Plugs.RequireAuth do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    token = Enum.at(get_req_header(conn, "x-auth"), 0)
    case Phoenix.Token.verify(conn, "user_id",
          token, max_age: 86400) do
      {:ok, user_id} ->
        user = Events.Users.get_user!(user_id)
        assign(conn, :current_user, user)
      {:error, err} ->
        conn
        |> put_resp_header(
          "content-type", "application/json; charset=UTF-8")
        |> send_resp(
          :unprocessable_entity,
          Jason.encode!(%{"error" => err})
        )
        |> halt()
    end
  end
end