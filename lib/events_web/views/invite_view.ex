defmodule EventsWeb.InviteView do
  use EventsWeb, :view
  alias EventsWeb.InviteView

  def render("index.json", %{invites: invites}) do
    %{data: render_many(invites, InviteView, "invite.json")}
  end

  def render("show.json", %{invite: invite}) do
    %{data: render_one(invite, InviteView, "invite.json")}
  end

  def render("invite.json", %{invite: invite}) do
    event_json = EventsWeb.EventView.render_json(invite.event)
    %{id: invite.id,
      response: invite.response,
      event: event_json,
      user_email: invite.user_email,
    }
  end
end
