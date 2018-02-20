defmodule Parko.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :start_time, :integer
      add :end_time, :integer
      add :amount, :float
      add :payment_date, :date
      add :due_date, :date
      add :booking_id, references(:bookings, on_delete: :nothing)
      timestamps()
    end
    create index(:payments, [:booking_id])
  end
end
