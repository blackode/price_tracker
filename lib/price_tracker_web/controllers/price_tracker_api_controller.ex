defmodule PriceTrackerWeb.PriceTrackerAPIController do
  use PriceTrackerWeb, :controller

  def get_current_price(conn, params) do
    response =
      if Utils.has_value(params["link"]) do
        case PriceTracker.make_request(params["link"]) do
          {:ok, response} ->
            %{
              status: true,
              price_data: response
            }

          {:error, error} ->
            %{
              status: false,
              error: error
            }
        end
      else
        %{
          status: false,
          error: %{error: "Link Not Available"}
        }
      end

    status_code = if response.status, do: 200, else: 422

    conn
    |> put_status(status_code)
    |> json(response)
  end
end
