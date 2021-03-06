defmodule Events.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :photo_hash, :string
    has_many :events, Events.UserEvents.Event
    has_many :comments, Events.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :photo_hash])
    |> validate_required([:email, :name])
    |> unique_constraint(:email)
  end
end
