defmodule Events.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string, null: false
      add :photo_hash, :string, null: false, default: ""

      timestamps()
    end
    
    # Emails are unique
    create unique_index(:users, [:email])
  end

end
