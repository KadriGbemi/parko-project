defmodule Parko.UserTest do
  use Parko.ModelCase

  alias Parko.User

  @valid_attrs %{name: "Bruno produit", password: "foo", username: "bruno", email: "bruno@gmail.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
