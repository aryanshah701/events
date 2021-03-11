defmodule Events.UserEvents.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :date, :naive_datetime
    field :description, :string
    field :name, :string
    belongs_to :user, Events.Users.User
    has_many :comments, Events.Comments.Comment
    has_many :invites, Events.Invites.Invite

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :date, :description, :user_id])
    |> validate_required([:name, :date, :description, :user_id])
    |> validate_date(:date)
  end

  # Design for custom changeset taken from 
  # https://medium.com/@QuantLayer/writing-custom-validations-for-ecto-changesets-4971881c7684

  # Ensures the datetime chosen is sometime in the future
  def validate_date(changeset, field, options \\ []) do
    current_datetime = NaiveDateTime.utc_now()

    validate_change(changeset, field, fn _, date ->
      if date != nil && NaiveDateTime.compare(current_datetime, date) == :gt do
        [{field, options[:message] || "Invalid date and time"}]
      else
        []
      end
    end)
  end

end
