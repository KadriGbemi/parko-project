defmodule Parko.BookingTest do
  use Parko.ModelCase

  alias Parko.Booking

  @valid_attrs %{end_time: 42, payment_method: "some payment_method", start_time: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Booking.changeset(%Booking{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Booking.changeset(%Booking{}, @invalid_attrs)
    refute changeset.valid?
  end
end
