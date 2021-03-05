defmodule Events.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :date, :naive_datetime, null: false
      add :description, :string, null: false, default: ""

      timestamps()
    end

  end
end
