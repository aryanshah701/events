defmodule EventsWeb.EventController do
  use EventsWeb, :controller

  alias Events.UserEvents
  alias Events.UserEvents.Event
  alias EventsWeb.ControllerHelpers
  alias EventsWeb.Plugs

  # Events can be created, edited, shown, and deleted only by logged in users
  plug Plugs.RequireLoggedIn, "en" when action in [:new, :create, :show, :edit, :update, :delete]

  # Add the event onto the connection so that the next few plugs have access to the event
  plug Plugs.AddEvent, "en" when action in [:edit, :update, :delete, :show]

  # Events can be edited and deleted by the owner of an event
  plug Plugs.RequireOwner, "en" when action in [:edit, :update, :delete]

  # Events can only be shown to the owner of the event and the invites of the event
  plug Plugs.RequireOwnerInvite, "en" when action in [:show]

  def index(conn, _params) do
    events = UserEvents.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = UserEvents.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    user = conn.assigns[:user]

    # Add in the formatted date and the owner
    formatted_event_params = event_params
    |> ControllerHelpers.format_event_params
    |> ControllerHelpers.add_user(user)

    IO.inspect formatted_event_params

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

    # Add in the formatted date
    formatted_event_params = event_params
    |> ControllerHelpers.format_event_params

    case UserEvents.update_event(event, formatted_event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect changeset
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
