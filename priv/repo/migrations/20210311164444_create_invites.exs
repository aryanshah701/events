defmodule Events.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :response, :string
      add :user_email, :string, null: false
      add :event_id, references(:events, on_delete: :nothing), null: false

      timestamps()
    end

    # Invites are unique
    create unique_index(:invites, [:user_email, :event_id], name: :unique_idx)
    create index(:invites, [:event_id])
  end
end
