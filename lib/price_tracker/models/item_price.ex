defmodule PriceTracker.Models.ItemPrice do
  use Instream.Series
  require Logger
  alias PriceTracker.Influx

  series do
    database("item_price")
    measurement("price")

    tag(:item_uuid)

    field :price
  end

  @doc """

  #### Input

  ```elixir
  attrs =  %{price: 789, uuid: "e760bdaa-6edf-11eb-98b9-2c56dc0a9e2c"}


  PriceTracker.Models.ItemPrice.insert(user)
  ```
  #### Output

  ```elixir
  [debug] [write] 1 points
  :ok
  ```
  """
  @spec insert(map) :: map
  def insert(attrs \\ %{}) do
    Influx.write(%__MODULE__{
      fields: %__MODULE__.Fields{price: attrs[:price]},
      tags: %__MODULE__.Tags{item_uuid: attrs[:uuid]}
    })
  end

  @doc """

  #### Input

  ```elixir
  map =  %{
  database: "item_price",
  points: [
    %{
      database: "item_price",
      fields: %{answer: 589},
      measurement: "price",
      tags: %{item_uuid: "e760bdaa-6edf-11eb-98b9-2c56dc0a9e2c"}
    },
    %{
      database: "item_price",
      fields: %{answer: 589},
      measurement: "price",
      tags: %{item_uuid: "e760bdaa-6edf-11eb-98b9-2c56dc0a9e2c"}
    },
    %{
      database: "item_price",
      fields: %{answer: 589},
      measurement: "price",
      tags: %{item_uuid: "e760bdaa-6edf-11eb-98b9-2c56dc0a9e2c"}
    }
  ]
  }


  PriceTracker.Models.ItemPrice.insert_many(map)
  ```
  #### Output

  ```elixir
  [debug] [write] 1 points
  :ok
  ```
  """
  @spec insert_many(map) :: map
  def insert_many(attrs \\ %{}) do
    Influx.write(attrs)
  end

  def get_item_price_by_uuid(uuid) do
    query = "SELECT * FROM price where item_uuid = '#{uuid}'"
    response = PriceTracker.Influx.query(query, database: "item_price")

    case response do
      %{
        results: [
          %{
            series: data,
            statement_id: 0
          }
        ]
      } ->
        [data] = data
        {:ok, %{count: length(data.values), data: data}}

      %{error: message} ->
        Logger.error(inspect(message))
        {:error, %{count: 0}}

      %{results: [%{statement_id: 0}]} ->
        {:error, %{count: 0}}
    end
  end
end
