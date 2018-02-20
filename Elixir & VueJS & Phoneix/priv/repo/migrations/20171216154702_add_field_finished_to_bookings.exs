defmodule Parko.Repo.Migrations.AddFieldFinishedToBookings do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
    add :finished, :boolean, default: false
  end
  end
end 
