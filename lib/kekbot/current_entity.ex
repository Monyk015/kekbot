defmodule Kekbot.CurrentEntity do
  use Agent

  @name __MODULE__
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def set_current_entity(user_id, entity_id) do
    Agent.update(@name, fn map -> Map.put(map, user_id, entity_id) end)
  end

  def get_current_entity(user_id) do
    Agent.get(@name, fn map -> Map.get(map, user_id) end)
  end
end
