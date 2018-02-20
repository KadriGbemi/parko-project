defmodule Parko.Park do
  use Parko.Web, :model

  schema "parks" do
    field :address, :string
    field :zone, :string
    field :lat, :float
    field :lng, :float
    field :is_road, :boolean, default: false
    field :available_space, :integer
    field :total_space, :integer
    has_many :points, Parko.Point
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:address, :zone, :lat, :lng, :is_road, :available_space, :total_space])
    |> validate_required([:address, :zone, :lat, :lng, :is_road, :available_space, :total_space])
  end
end
