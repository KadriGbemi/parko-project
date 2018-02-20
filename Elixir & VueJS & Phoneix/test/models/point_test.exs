defmodule Parko.PointTest do
  use Parko.ModelCase

  alias Parko.Point

  @valid_attrs %{park_id: 1, lat: 58.381895, lng: 26.730692}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Point.changeset(%Point{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Point.changeset(%Point{}, @invalid_attrs)
    refute changeset.valid?
  end
end
