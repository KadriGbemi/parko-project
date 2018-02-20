defmodule Parko.Repo.Migrations.CreateBooking do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :payment_method, :string
      add :start_time, :integer
      add :end_time, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :park_id, references(:parks, on_delete: :nothing)

      timestamps()
    end

    create index(:bookings, [:user_id])
    create index(:bookings, [:park_id])
  end
end
