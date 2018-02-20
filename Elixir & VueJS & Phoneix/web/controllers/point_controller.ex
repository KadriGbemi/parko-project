defmodule Parko.PointController do
  use Parko.Web, :controller

  alias Parko.Point

  def index(conn, _params) do
    points = Repo.all(Point)
    render(conn, "index.html", points: points)
  end

  def new(conn, _params) do
    changeset = Point.changeset(%Point{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"point" => point_params}) do
    changeset = Point.changeset(%Point{}, point_params)

    case Repo.insert(changeset) do
      {:ok, point} ->
        conn
        |> put_flash(:info, "Point created successfully.")
        |> redirect(to: point_path(conn, :show, point))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    point = Repo.get!(Point, id)
    render(conn, "show.html", point: point)
  end

  def edit(conn, %{"id" => id}) do
    point = Repo.get!(Point, id)
    changeset = Point.changeset(point)
    render(conn, "edit.html", point: point, changeset: changeset)
  end

  def update(conn, %{"id" => id, "point" => point_params}) do
    point = Repo.get!(Point, id)
    changeset = Point.changeset(point, point_params)

    case Repo.update(changeset) do
      {:ok, point} ->
        conn
        |> put_flash(:info, "Point updated successfully.")
        |> redirect(to: point_path(conn, :show, point))
      {:error, changeset} ->
        render(conn, "edit.html", point: point, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    point = Repo.get!(Point, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(point)

    conn
    |> put_flash(:info, "Point deleted successfully.")
    |> redirect(to: point_path(conn, :index))
  end
end
