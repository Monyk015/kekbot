defmodule Kekbot.Bot do
  alias Kekbot.Bot.Entity
  alias Kekbot.Bot.Tag
  alias Kekbot.Repo
  alias Kekbot.CurrentEntity
  import Ecto.Query
  def api_url, do: "https://api.telegram.org/bot#{Application.fetch_env!(:kekbot, :bot_token)}/"

  def req(path, body) do
    IO.inspect(body)

    IO.inspect Poison.encode!(body)
    case HTTPoison.post(api_url() <> path, Poison.encode!(body), [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{body: body}} ->
        IO.inspect Poison.decode!(body)
    end

  end

  def handle_sticker(message, sticker) do
    user_id = message["from"]["id"]
    file_id = sticker["file_id"]
    existing = Repo.get_by(Entity, user_id: user_id, file_id: file_id)

    case existing do
      %Entity{} = existing ->
        CurrentEntity.set_current_entity(user_id, existing.id)
        IO.inspect(CurrentEntity.get_current_entity(user_id))

      nil ->
        entity =
          Entity.changeset(%Entity{}, %{
            "user_id" => user_id,
            "type" => "sticker",
            "file_id" => file_id,
            "data" => sticker
          })

        {:ok, entity} = Repo.insert(entity)
        CurrentEntity.set_current_entity(user_id, entity.id)
        IO.inspect(CurrentEntity.get_current_entity(user_id))
    end
  end

  def handle_message(message, text) do
    user_id = message["from"]["id"]
    current_entity_id = CurrentEntity.get_current_entity(user_id)

    if current_entity_id == nil do
      :ok
    else
      entity =
        Repo.get(Entity, current_entity_id)
        |> Repo.preload(:tags)

      tags = entity.tags

      if Enum.any?(tags, fn tag -> tag.name == text end) do
        :ok
      else
        tags = [Tag.changeset(%Tag{}, %{"user_id" => user_id, "name" => text})] ++ tags

        entity
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:tags, tags)
        |> Repo.update!()
      end
    end
  end

  def handle_query(query) do
    IO.inspect(query)
    user_id = query["from"]["id"]
    id = query["id"]
    text = query["query"]
    like_expr = "%#{text}%"
    query = from e in Entity,
      join: t in assoc(e, :tags),
      where: like(t.name, ^like_expr) and e.user_id == ^user_id
    entities = Repo.all(query)


    IO.inspect entities
    results =
      Enum.map(entities, fn entity ->
        %{
          "type" => entity.type,
          "id" => Integer.to_string(entity.id),
          "sticker_file_id" => entity.file_id
        }
      end)


    req("answerInlineQuery", %{
      "inline_query_id" => id,
      "results" => results,
      "is_personal" => true,
      "cache_time" => 0
    })
  end
end
