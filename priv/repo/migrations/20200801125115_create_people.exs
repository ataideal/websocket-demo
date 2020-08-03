defmodule Websocket.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name, :string
      add :role, :string
      add :photo, :string
      add :parent_id, references(:people, on_delete: :delete_all)

      timestamps()
    end

  end
end
