defmodule PriceTracker.Repo do
  use Ecto.Repo,
    otp_app: :price_tracker,
    adapter: Ecto.Adapters.Postgres
end
