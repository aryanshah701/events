defmodule EventsWeb.EventController do
  use EventsWeb, :controller

  alias Events.UserEvents
  alias Events.UserEvents.Event
  alias EventsWeb.ControllerHelpers

  def index(conn, _params) do
    events = UserEvents.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = UserEvents.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    IO.inspect event_params["date"]
    formatted_event_params = ControllerHelpers.format_event_params(event_params)

    IO.puts "After"
    IO.inspect formatted_event_params["date"]

    case UserEvents.create_event(formatted_event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = UserEvents.get_event!(id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = UserEvents.get_event!(id)
    changeset = UserEvents.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = UserEvents.get_event!(id)

    case UserEvents.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = UserEvents.get_event!(id)
    {:ok, _event} = UserEvents.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
