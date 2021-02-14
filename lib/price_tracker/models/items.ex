defmodule PriceTracker.Models.Items do
  import Ecto.Query, warn: false
  import Ecto.Changeset

  use Ecto.Schema

  alias PriceTracker.Repo

  @primary_key {:item_id, :id, autogenerate: true}
  @derive {Phoenix.Param, key: :item_id}

  @type t :: %__MODULE__{}
  schema "items" do
    field(:name, :string)
    field(:url, :string)
    field(:uuid, :string)
    timestamps()
  end

  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [
      :item_id,
      :name,
      :url,
      :uuid
    ])
    |> validate_required([
      :name,
      :url,
      :uuid
    ])
    |> unique_constraint(:name)
  end

  @doc """

  #### Input

  ```elixir
  user = %{
      email: "mahesh@test.in",
      full_name: "Mahesh Reddy",
      password: "123456",
      age: 26
    }

  AtriaTask2.Models.Users.create_user(user)
  ```
  #### Output

  ```elixir
  {:ok,
   %AtriaTask2.Models.Users{
     __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
     age: 26,
     email: "mahesh@test.in",
     full_name: "Mahesh Reddy",
     inserted_at: ~N[2021-02-06 12:15:31],
     password: "$2b$12$NEC0.BfL6NhKDGUrCh.l8O6WC1pkB3wDzIgfor6nHloW0a/S/0uGC",
     updated_at: ~N[2021-02-06 12:15:31],
     user_id: 1
   }}

  ```
  """
  @spec insert(map) :: map
  def insert(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
