defmodule Events.Invites.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invites" do
    field :response, :string
    field :user_email, :string
    belongs_to :event, Events.UserEvents.Event

    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:response, :user_email, :event_id])
    |> validate_required([:response, :user_email, :event_id])
  end
end
