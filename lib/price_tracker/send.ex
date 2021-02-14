defmodule Send do
  require Logger

  def request(params) do
    case HTTPoison.request(params.method, params[:endpoint], params[:data], params[:headers]) do
      {:ok, response} ->
        {:ok, response}

      error ->
        Logger.error(inspect(error))
        {:error, "error"}
    end
  end
end
