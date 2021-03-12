defmodule EventsWeb.EventView do
  use EventsWeb, :view

  # Function from Tuck notes 0309 post_view.ex
  def render_json(%Events.UserEvents.Event{} = event) do
    IO.puts "EVENT"
    IO.inspect event
    %{
      id: event.id,
      num_invites: event.num_invites,
      num_no: event.num_no,
      num_yes: event.num_yes,
      num_maybe: event.num_maybe,
      num_no_response: event.num_no_response,
    }
  end
end
