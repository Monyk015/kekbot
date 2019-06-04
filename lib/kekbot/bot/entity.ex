defmodule Kekbot.Bot.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entities" do
    field :data, :map
    field :type, :string
    field :user_id, :integer
    field :file_id, :string
    many_to_many :tags, Kekbot.Bot.Tag, join_through: "entities_tags"

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:type, :user_id, :data, :file_id])
    |> validate_required([:type, :user_id, :data, :file_id])
  end
end
