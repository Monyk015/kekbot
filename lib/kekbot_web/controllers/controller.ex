defmodule KekbotWeb.Controller do
  use KekbotWeb, :controller

  def hello(conn, _), do: json(conn, %{"message" => "hello1"})
end
