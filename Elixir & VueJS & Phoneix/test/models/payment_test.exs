defmodule Parko.PaymentTest do
  use Parko.ModelCase

  alias Parko.Payment

  @valid_attrs %{start_time: 1, end_time: 2, amount: 3.0, payment_date: 10/12/2017, due_date: 10/12/2017}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Payment.changeset(%Payment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Payment.changeset(%Payment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
