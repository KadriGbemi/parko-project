defmodule Parko.ParkTest do
  use Parko.ModelCase

  alias Parko.Park

  @valid_attrs %{address: "some address", available_space: 42, is_road: true, lat: 120.5, lng: 120.5, total_space: 42, zone: "some zone"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Park.changeset(%Park{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Park.changeset(%Park{}, @invalid_attrs)
    refute changeset.valid?
  end
end
