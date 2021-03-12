defmodule EventsWeb.UserController do
  use EventsWeb, :controller

  alias Events.Users
  alias Events.Users.User
  alias Events.Photos

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    # Add the photo_hash to the user_params
    # Following 3 lines from Tuck Notes 0309 post_controller.ex
    photo = user_params["photo"]
    {:ok, hash} = Photos.save_photo(photo.filename, photo.path)
    user_params = Map.put(user_params, "photo_hash", hash)
    
    # Create the user and send him/her to login page
    case Users.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "You have been registered!")
        |> redirect(to: Routes.page_path(conn, :login))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  # Responds with the photo of the given user
  # Taken from Tuck notes 0309 post_controller.ex
  def photo(conn, %{"id" => _id}) do
    user = conn.assigns[:user]
    {:ok, _name, data} = Photos.load_photo(user.photo_hash)
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, data)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    photo = user_params["photo"]
    {:ok, hash} = Photos.save_photo(photo.filename, photo.path)
    user_params = Map.put(user_params, "photo_hash", hash)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
