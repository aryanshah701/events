defmodule EventsWeb.InviteController do
  use EventsWeb, :controller

  alias Events.Invites
  alias Events.Invites.Invite

  action_fallback EventsWeb.FallbackController

  def index(conn, _params) do
    invites = Invites.list_invites()
    render(conn, "index.json", invites: invites)
  end

  def create(conn, %{"invite" => invite_params}) do
    # Add the user email if it isn't part of the request
    if !invite_params["user_email"] do
      invite_params = Map.put(invite_params, "user_email", conn.assigns[:current_user].email)
      IO.inspect invite_params
      
      with {:ok, %Invite{} = invite} <- Invites.create_invite(invite_params) do
        invite = Invites.load_invite(invite)

        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.invite_path(conn, :show, invite))
        |> render("show.json", invite: invite)
      end
    else
      with {:ok, %Invite{} = invite} <- Invites.create_invite(invite_params) do
        invite = Invites.load_invite(invite)

        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.invite_path(conn, :show, invite))
        |> render("show.json", invite: invite)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    render(conn, "show.json", invite: invite)
  end

  def update(conn, %{"id" => id, "invite" => invite_params}) do
    invite = Invites.get_invite!(id)

    with {:ok, %Invite{} = invite} <- Invites.update_invite(invite, invite_params) do
      render(conn, "show.json", invite: invite)
    end
  end

  def delete(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)

    with {:ok, %Invite{}} <- Invites.delete_invite(invite) do
      send_resp(conn, :no_content, "")
    end
  end
end
