defmodule Events.UserEvents.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :date, :naive_datetime
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :date, :description])
    |> validate_required([:name, :date, :description])
    |> validate_date()
  end

  # Ensuring the event's date and time is greater than the current date time
  def validate_date(changeset) do
    date = get_field(changeset, :date)
    current_datetime = NaiveDateTime.utc_now()

    if NaiveDateTime.compare(current_datetime, date) == :gt do
      add_error(changeset, :date, "cannot be prior to the current date and time")
    else
      changeset
    end
  end

end
