defmodule Kekbot.Repo do
  use Ecto.Repo,
    otp_app: :kekbot,
    adapter: Ecto.Adapters.Postgres
end
