defmodule Kekbot.Repo.Migrations.CreateEntities do
  use Ecto.Migration

  def change do
    create table(:entities) do
      add :type, :string
      add :user_id, :integer
      add :data, :map
      add :file_id, :string

      timestamps()
    end

  end
end
