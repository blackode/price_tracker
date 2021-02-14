defmodule Utils do
  @doc """
  Returns `true` if the `val` is empty; otherwise returns `false`

  ### Examples

      iex> Utils.has_value(%{})
      true

      iex> Utils.has_value(nil)
      true

      iex> Utils.has_value([])
      true

      iex> Utils.has_value("  ")
      true

      iex> Utils.has_value("s")
      false
  """
  def has_value(val) when is_nil(val) do
    !true
  end

  def has_value(val) when is_binary(val) do
    val = String.trim(val)
    !(byte_size(val) == 0)
  end

  def has_value(val) when is_list(val) do
    !Enum.empty?(val)
  end

  def has_value(val) when is_map(val) do
    !(map_size(val) == 0)
  end

  def has_value(val) when is_tuple(val) do
    !(tuple_size(val) == 0)
  end

  def has_value(_val) do
    !false
  end
end
