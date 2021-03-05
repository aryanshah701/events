defmodule EventsWeb.PageController do
  use EventsWeb, :controller

  alias Events.UserEvents

  def index(conn, _params) do
    events = UserEvents.list_events()
    render(conn, "index.html", events: events)
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end
end
