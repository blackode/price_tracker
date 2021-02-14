defmodule SupplierHosts do
  @suppliercodes %{
    "www.amazon.in" => AmazonInAPI
  }
  def supplier_codes(), do: @suppliercodes
  def get_module_name(url), do: @suppliercodes[url]
end
