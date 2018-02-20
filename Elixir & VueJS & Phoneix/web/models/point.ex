defmodule Parko.Point do
  use Parko.Web, :model

  schema "points" do
    field :lat, :float
    field :lng, :float
    belongs_to :park, Parko.Park, foreign_key: :park_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:park_id, :lat, :lng])
    |> validate_required([:park_id, :lat, :lng])
  end
end
