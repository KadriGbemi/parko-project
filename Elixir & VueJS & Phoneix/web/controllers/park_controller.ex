defmodule Parko.ParkController do
  use Parko.Web, :controller

  alias Parko.Park

  def index(conn, _params) do
    parks = Repo.all(Park)
    render(conn, "index.html", parks: parks)
  end

  def new(conn, _params) do
   
    changeset = Park.changeset(%Park{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"park" => park_params}) do
    changeset = Park.changeset(%Park{}, park_params)

    case Repo.insert(changeset) do
      {:ok, park} ->
        conn
        |> put_flash(:info, "Park created successfully.")
        |> redirect(to: park_path(conn, :show, park))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    park = Repo.get!(Park, id)
    render(conn, "show.html", park: park)
    
  end

  def edit(conn, %{"id" => id}) do
    park = Repo.get!(Park, id)
    changeset = Park.changeset(park)
    render(conn, "edit.html", park: park, changeset: changeset)
  end

  def update(conn, %{"id" => id, "park" => park_params}) do
    park = Repo.get!(Park, id)
    changeset = Park.changeset(park, park_params)

    case Repo.update(changeset) do
      {:ok, park} ->
        conn
        |> put_flash(:info, "Park updated successfully.")
        |> redirect(to: park_path(conn, :show, park))
      {:error, changeset} ->
        render(conn, "edit.html", park: park, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    park = Repo.get!(Park, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(park)

    conn
    |> put_flash(:info, "Park deleted successfully.")
    |> redirect(to: park_path(conn, :index))
  end
end
