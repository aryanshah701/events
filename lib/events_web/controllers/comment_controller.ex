defmodule EventsWeb.CommentController do
  use EventsWeb, :controller

  alias Events.Comments
  alias Events.Comments.Comment

  # Comments can be created, edited, shown, and deleted only by logged in users
  plug Plugs.RequireLoggedIn, "en" when action in [:new, :create, :show, :edit, :update, :delete]

  # Add the comment onto the connection so that the next few plugs have access to the event
  plug Plugs.AddComment, "en" when action in [:edit, :update, :delete, :show]

  # # Add the event onto the connection so that the next few plugs have access to the event
  # plug Plugs.AddEvent, "en" when action in [:edit, :update, :delete, :show]

  # # Comments can be deleted by the owner of the event and the owner of the comment
  # plug Plugs.RequireSomeOwner, "en" when action in [:delete]

  # # Comments can be editing by the owner of the comment only
  # plug Plugs.RequireCommentOwner, "en" when action in [:edit, :update]

  # # Comments can only be shown to the owner of the event, and invitees 
  # plug Plugs.RequireOwnerInvite, "en" when action in [:show]

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    # Add the user_id and event_id into the comment
    updated_params = comment_params
    |> Map.put("user_id", conn.assigns[:user].id)

    event_id = comment_params["event_id"]
    event = Events.UserEvents.get_event(event_id)

    case Comments.create_comment(updated_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    changeset = Comments.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.comment_path(conn, :index))
  end
end
