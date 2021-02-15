defmodule PriceTracker do
  require Logger
  alias PriceTracker.Models.{Items, ItemPrice}

  @moduledoc """
  PriceTracker keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def make_request(price_link) do
    params = %{
      method: :get,
      endpoint: price_link,
      data: "",
      headers: [{"Accept", "application/json"}]
    }

    case Send.request(params) do
      {:ok, response} ->
        domain_details = URI.parse(response.request_url)
        url = domain_details.host

        {:ok, parsed_document} = Floki.parse_document(response.body)
        module_name = SupplierHosts.get_module_name(url)

        case apply(module_name, :get_price_details, [url, parsed_document]) do
          {:ok, price_data} ->
            price_data =
              price_data
              |> Map.put(:link, price_link)
              |> Map.merge(%{status: true})

            price_data =
              case save_item_details(price_data) do
                {:ok, data} ->
                  Map.merge(data, price_data)

                {:error, data} ->
                  Map.merge(data, price_data)
              end

            {:ok, price_data}

          {:error, error} ->
            {:error, error}
        end

      error ->
        Logger.error(inspect(error))
        {:error, %{error: "Request Failed"}}
    end
  end

  def save_item_details(price_data) do
    uuid = UUID.uuid3(:dns, price_data.name)

    item_data = %{
      name: price_data.name,
      uuid: uuid,
      url: price_data.link
    }

    item_price_data = %{
      uuid: uuid,
      price: price_data.price
    }

    case Items.find(uuid) do
      nil ->
        case Items.insert(item_data) do
          {:ok, item} ->
            ItemPrice.insert(item_price_data)
            ItemPrice.get_item_price_by_uuid(item.uuid)

          {:error, changeset} ->
            {:ok, changeset}
        end

      item ->
        ItemPrice.get_item_price_by_uuid(item.uuid)
    end
  end
end
