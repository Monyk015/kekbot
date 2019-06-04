defmodule KekbotWeb.Controller do
  use KekbotWeb, :controller
  import Kekbot.Bot

  def hello(conn, _), do: json(conn, %{"message" => "hello1"})

  def handle(conn, %{"message" => %{"sticker" => sticker}} = params) do
    IO.puts "handling sticker"
    handle_sticker(params["message"], sticker)
    conn |> send_resp(200, "")
  end

  def handle(conn, %{"message" => %{"text" => text}} = params) do
    IO.puts "handling message"
    handle_message(params["message"], text)
    conn |> send_resp(200, "")
  end

  def handle(conn, %{"inline_query" => query} = params) do
    IO.inspect params
    handle_query(query)
    conn |> send_resp(200, "")
  end

  def handle(conn, params) do
    IO.inspect params
    conn |> send_resp(200, "")
  end
end
