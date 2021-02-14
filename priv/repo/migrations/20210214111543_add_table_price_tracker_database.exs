defmodule PriceTracker.Repo.Migrations.AddTablePriceTrackerDatabase do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add(:item_id, :serial, primary_key: true)
      add(:name, :text)
      add(:url, :text)
      add(:uuid, :string)

      timestamps()
    end

    create unique_index(:items, [:name])
  end
end
