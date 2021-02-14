defmodule AmazonInAPI do
  require Logger
  # Amazon India
  def get_price_details("www.amazon.in" = url, parsed_document) do
    ## Item Name
    name =
      parsed_document
      |> Floki.find("span.product-title-word-break")
      |> Floki.text()
      |> WordSmith.squish()

    ## Normal Price without any deals
    normal_price =
      parsed_document
      |> Floki.find("span.priceBlockBuyingPriceString")
      |> Floki.text()
      |> get_price_in_decimal

    ## Normal Price without any deals
    deal_price =
      parsed_document
      |> Floki.find("span.priceBlockDealPriceString")
      |> Floki.text()
      |> get_price_in_decimal

    {:ok, %{price: deal_price || normal_price, name: name, host: url}}
  end

  def get_price_in_decimal(price) do
    cond do
      price == "" ->
        nil

      true ->
        case Money.parse(price, :INR) do
          {:ok, money} ->
            money.amount / 100

          error ->
            Logger.error(inspect(error))
            nil
        end
    end
  end
end
