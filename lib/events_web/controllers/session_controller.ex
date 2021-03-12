# Session logic inspired by Nat Tuck notes 0302
defmodule EventsWeb.SessionController do
  use EventsWeb, :controller

  alias Events.Users

  # Logs the user in
  def create(conn, %{"email" => email}) do
    # If user email exists then log in, else put error flash
    user = Users.get_user_by_email(email)

    if user do
      conn = put_session(conn, :user_id, user.id)
      conn
      |> put_flash(:info, "Logged in Sucessfully!")
      |> redirect(to: Routes.user_path(conn, :show, user))

    else
      conn
      |> put_flash(:error, "Invalid email")
      |> redirect(to: Routes.page_path(conn, :login))
    end
  end

  # Logs the user out
  def delete(conn, _params) do
    # If user is logged in then log out, else put error flash
    if conn.assigns[:user] do
      conn
      |> delete_session(:user_id)
      |> put_flash(:info, "Logged out Sucessfully!")
      |> redirect(to: Routes.page_path(conn, :index))

    else
      conn
      |> put_flash(:info, "Logged out Sucessfully!")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

end
