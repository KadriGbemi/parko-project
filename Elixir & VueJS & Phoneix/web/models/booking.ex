defmodule Parko.Booking do
  use Parko.Web, :model

  schema "bookings" do
    field :payment_method, :string
    field :start_time, :integer
    field :end_time, :integer
    field :finished, :boolean
    field :released, :boolean
    belongs_to :user, Parko.User, foreign_key: :user_id
    belongs_to :park, Parko.Park, foreign_key: :park_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:payment_method, :start_time, :end_time])
    |> validate_required([:payment_method, :start_time, :end_time])
  end
end
