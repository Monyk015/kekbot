defmodule Kekbot.Bot.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    field :user_id, :integer
    many_to_many :entities, Kekbot.Bot.Entity, join_through: "entities_tags"

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:user_id, :name])
    |> validate_required([:user_id, :name])
  end
end
