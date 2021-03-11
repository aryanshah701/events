defmodule Events.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    belongs_to :user, Events.Users.User
    belongs_to :event, Events.UserEvents.Event

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :user_id, :event_id])
    |> validate_required([:content, :user_id, :event_id])
  end
end
