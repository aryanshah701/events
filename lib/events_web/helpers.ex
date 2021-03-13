defmodule EventsWeb.Helpers do
  alias Events.Users

  def get_user_name(user_id) do
    Users.get_user(user_id).name
  end

  def get_user_id(user_email) do
    Users.get_user_by_email(user_email).id
  end

  def response_to_string(resp) do
    case resp do
      "yes" -> "Attending"
      "no" -> "Not Attending"
      "maybe" -> "Not Attending"
      _ -> "No Response"
    end
  end

  def invited_user?(invites, user) do
    user_email = user.email
    Enum.any?(invites, fn invite -> invite.user_email == user_email end)
  end

  def get_redirect_uri(conn) do
    if Map.has_key?(conn.query_params, "redirect") do
      conn.query_params["redirect"]
    else
      nil
    end
  end

end