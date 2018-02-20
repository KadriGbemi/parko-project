defmodule Parko.Repo.Migrations.AddAttributeReleasedToBooking do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :released, :boolean, default: false
  end
  end
end 
