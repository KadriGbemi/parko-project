defmodule Parko.ParkControllerTest do
  use Parko.ConnCase

  alias Parko.Park
  @valid_attrs %{address: "some address", available_space: 42, is_road: true, lat: 120.5, lng: 120.5, total_space: 42, zone: "some zone"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, park_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing parks"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, park_path(conn, :new)
    assert html_response(conn, 200) =~ "New park"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, park_path(conn, :create), park: @valid_attrs
    park = Repo.get_by!(Park, @valid_attrs)
    assert redirected_to(conn) == park_path(conn, :show, park.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, park_path(conn, :create), park: @invalid_attrs
    assert html_response(conn, 200) =~ "New park"
  end

  test "shows chosen resource", %{conn: conn} do
    park = Repo.insert! %Park{}
    conn = get conn, park_path(conn, :show, park)
    assert html_response(conn, 200) =~ "Show park"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, park_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    park = Repo.insert! %Park{}
    conn = get conn, park_path(conn, :edit, park)
    assert html_response(conn, 200) =~ "Edit park"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    park = Repo.insert! %Park{}
    conn = put conn, park_path(conn, :update, park), park: @valid_attrs
    assert redirected_to(conn) == park_path(conn, :show, park)
    assert Repo.get_by(Park, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    park = Repo.insert! %Park{}
    conn = put conn, park_path(conn, :update, park), park: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit park"
  end

  test "deletes chosen resource", %{conn: conn} do
    park = Repo.insert! %Park{}
    conn = delete conn, park_path(conn, :delete, park)
    assert redirected_to(conn) == park_path(conn, :index)
    refute Repo.get(Park, park.id)
  end
end
