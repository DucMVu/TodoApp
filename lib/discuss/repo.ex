defmodule Discuss.Repo do
  use Ecto.Repo,
    otp_app: :discuss,
    adapter: Ecto.Adapters.Postgres

  use Scrivener,
    page_size: 10
end
