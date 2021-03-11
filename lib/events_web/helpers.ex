defmodule EventsWeb.Helpers do
  alias Events.Users

  def get_user_name(user_id) do
    Users.get_user(user_id).name
  end
end