defmodule KekbotWeb.Controller do
  use KekbotWeb, :controller
  import Kekbot.Bot

  def hello(conn, _), do: json(conn, %{"message" => "hello1"})

  def updates(conn, _) do
    json(conn, get_updates())
  end
end
