defmodule Kekbot.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :user_id, :integer
      add :name, :string

      timestamps()
    end

    create table(:entities_tags) do
      add :entity_id, references(:entities)
      add :tag_id, references(:tags)
    end
  end
end
