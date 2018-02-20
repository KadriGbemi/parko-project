defmodule Parko.Payment do
  use Parko.Web, :model

  schema "payments" do
    field :start_time, :integer
    field :end_time, :integer
    field :amount, :float
    field :payment_date, :date
    field :due_date, :date
    belongs_to :booking, Parko.Booking, foreign_key: :booking_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_time, :end_time, :amount, :payment_date, :due_date])
    |> validate_required([:start_time, :end_time, :amount, :payment_date, :due_date])
  end
end
