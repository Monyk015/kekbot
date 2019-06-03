defmodule Kekbot.Bot do
  def api_url, do:
    "https://api.telegram.org/bot#{Application.fetch_env!(:kekbot, :bot_token)}/"

  def req(path) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.post(api_url() <> path, "")
    body = Poison.decode!(body)
    body
  end

  def get_updates do
    req("getUpdates")
  end
end
