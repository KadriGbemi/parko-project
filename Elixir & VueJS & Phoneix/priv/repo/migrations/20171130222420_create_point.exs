defmodule Parko.Repo.Migrations.CreatePoint do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :lat, :float
      add :lng, :float
      add :park_id, references(:parks, on_delete: :nothing)

      timestamps()
    end

    create index(:points, [:park_id])
  end
end
