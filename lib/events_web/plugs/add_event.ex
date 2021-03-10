# Plug that adds the current event onto the connection
# Implemented using the Phoenix Docs: https://hexdocs.pm/phoenix/plug.html
defmodule EventsWeb.Plugs.AddEvent do 
  import Plug.Conn

  alias Events.UserEvents

  def init(default), do: default

  def call(conn, _default) do
    # Get the current event's id
    event_id = conn.params["id"]

    # If the event id exists, add it onto the connection
    if event_id do
      event = UserEvents.get_event(event_id)
      assign(conn, :event, event)
    else
      assign(conn, :event, nil)
    end

  end

end