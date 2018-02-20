defmodule Parko.PointControllerTest do
  use Parko.ConnCase

  alias Parko.Point
  @valid_attrs %{lat: 120.5, lng: 120.5}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, point_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing points"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, point_path(conn, :new)
    assert html_response(conn, 200) =~ "New point"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, point_path(conn, :create), point: @valid_attrs
    point = Repo.get_by!(Point, @valid_attrs)
    assert redirected_to(conn) == point_path(conn, :show, point.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, point_path(conn, :create), point: @invalid_attrs
    assert html_response(conn, 200) =~ "New point"
  end

  test "shows chosen resource", %{conn: conn} do
    point = Repo.insert! %Point{}
    conn = get conn, point_path(conn, :show, point)
    assert html_response(conn, 200) =~ "Show point"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, point_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    point = Repo.insert! %Point{}
    conn = get conn, point_path(conn, :edit, point)
    assert html_response(conn, 200) =~ "Edit point"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    point = Repo.insert! %Point{}
    conn = put conn, point_path(conn, :update, point), point: @valid_attrs
    assert redirected_to(conn) == point_path(conn, :show, point)
    assert Repo.get_by(Point, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    point = Repo.insert! %Point{}
    conn = put conn, point_path(conn, :update, point), point: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit point"
  end

  test "deletes chosen resource", %{conn: conn} do
    point = Repo.insert! %Point{}
    conn = delete conn, point_path(conn, :delete, point)
    assert redirected_to(conn) == point_path(conn, :index)
    refute Repo.get(Point, point.id)
  end
end
