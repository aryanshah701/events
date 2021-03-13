defmodule EventsWeb.UserController do
  use EventsWeb, :controller

  alias Events.Users
  alias Events.Users.User
  alias Events.Photos
  alias EventsWeb.Plugs

  plug Plugs.RequireNotLoggedIn, "en" when action in [:new, :create]
  plug Plugs.RequireLoggedIn, "en" when action in [:index, :show, :edit, :update, :delete]
  plug Plugs.RequireUserOwner, "en" when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    # Get the redirect uri(if it exists)
    redirect_uri = EventsWeb.Helpers.get_redirect_uri(conn)

    # Add the photo_hash to the user_params
    # Following 3 lines from Tuck Notes 0309 post_controller.ex
    photo = user_params["photo"]

    # If the user has decided to put in a photo
    if photo do
      # Ensure that the photo ends with jpg, png, or gif
      if Events.Photos.is_valid_photo(photo) do
        conn
        |> put_flash(:error, "Please make sure your photo is a jpg, png, or gif") 
        |> redirect(to: Routes.user_path(conn, :new))
      end

      {:ok, hash} = Photos.save_photo(photo.filename, photo.path)
      user_params = Map.put(user_params, "photo_hash", hash)
      
      # Create the user and send him/her to login page
      case Users.create_user(user_params) do
        {:ok, user} ->
          conn = put_session(conn, :user_id, user.id)
          conn
          |> put_flash(:info, "You have been registered!")
          |> redirect(to: redirect_uri || Routes.user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      # Create the user and send him/her to login page(without photo)
      user_params = Map.put(user_params, "photo_hash", "")
      case Users.create_user(user_params) do
        {:ok, user} ->
          conn = put_session(conn, :user_id, user.id)
          conn
          |> put_flash(:info, "You have been registered!")
          |> redirect(to: redirect_uri || Routes.user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    logged_in_user_id = Integer.to_string(conn.assigns[:user].id)

    if id != logged_in_user_id do
      conn
      |> put_flash(:error, "Sorry you can't access someone else's user details")
      |> redirect(to: EventsWeb.Router.Helpers.user_path(conn, :show, logged_in_user_id))
      |> halt()
    else
      user = Users.get_user!(id)
      render(conn, "show.html", user: user)
    end
  end

  # Responds with the photo of the given user
  # Taken from Tuck notes 0309 post_controller.ex
  def photo(conn, %{"id" => _id}) do
    user = conn.assigns[:user]
    # If the user has a photo
    if user.photo_hash != "" do
      {:ok, _name, data} = Photos.load_photo(user.photo_hash)
      conn
      |> put_resp_content_type("image/jpeg")
      |> send_resp(200, data)
    else
      conn
      |> put_resp_content_type("image/jpeg")
      |> send_resp(200, "")
    end
  end

  def edit(conn, %{"id" => id}) do
    logged_in_user_id =  Integer.to_string(conn.assigns[:user].id)
    if id != logged_in_user_id do
      conn
      |> put_flash(:error, "Sorry you can't edit another user")
      |> redirect(to: EventsWeb.Router.Helpers.user_path(conn, :show, logged_in_user_id))
      |> halt()
    else
      user = Users.get_user!(id)
      changeset = Users.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    logged_in_user_id = Integer.to_string(conn.assigns[:user].id)

    if id != logged_in_user_id do
      conn
      |> put_flash(:error, "Sorry you can't edit another user")
      |> redirect(to: EventsWeb.Router.Helpers.user_path(conn, :show, logged_in_user_id))
      |> halt()
    else
      photo = user_params["photo"]

      if photo do
        # Ensure that the photo ends with jpg, png, or gif
        if Events.Photos.is_valid_photo(photo) do
          conn
          |> put_flash(:error, "Please make sure your photo is a jpg, png, or gif") 
          |> redirect(to: Routes.user_path(conn, :show, user))
        end

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
      else
        case Users.update_user(user, user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User updated successfully.")
            |> redirect(to: Routes.user_path(conn, :show, user))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", user: user, changeset: changeset)
        end
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    logged_in_user_id = Integer.to_string(conn.assigns[:user].id)
    
    if id != logged_in_user_id do
      conn
      |> put_flash(:error, "Sorry you can't edit another user")
      |> redirect(to: EventsWeb.Router.Helpers.user_path(conn, :show, logged_in_user_id))
      |> halt()
    else
      {:ok, _user} = Users.delete_user(user)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
