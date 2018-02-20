defmodule Parko.Repo.Migrations.CreatePark do
  use Ecto.Migration

  def change do
    create table(:parks) do
      add :address, :string
      add :zone, :string
      add :lat, :float
      add :lng, :float
      add :is_road, :boolean, default: false, null: false
      add :available_space, :integer
      add :total_space, :integer

      timestamps()
    end
  end
end
