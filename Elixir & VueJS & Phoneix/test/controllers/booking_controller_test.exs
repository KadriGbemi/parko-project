defmodule Parko.BookingControllerTest do
  use Parko.ConnCase

  alias Parko.Booking
  @valid_attrs %{end_time: 42, payment_method: "some payment_method", start_time: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, booking_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing bookings"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, booking_path(conn, :new)
    assert html_response(conn, 200) =~ "New booking"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, booking_path(conn, :create), booking: @valid_attrs
    booking = Repo.get_by!(Booking, @valid_attrs)
    assert redirected_to(conn) == booking_path(conn, :show, booking.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, booking_path(conn, :create), booking: @invalid_attrs
    assert html_response(conn, 200) =~ "New booking"
  end

  test "shows chosen resource", %{conn: conn} do
    booking = Repo.insert! %Booking{}
    conn = get conn, booking_path(conn, :show, booking)
    assert html_response(conn, 200) =~ "Show booking"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, booking_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    booking = Repo.insert! %Booking{}
    conn = get conn, booking_path(conn, :edit, booking)
    assert html_response(conn, 200) =~ "Edit booking"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    booking = Repo.insert! %Booking{}
    conn = put conn, booking_path(conn, :update, booking), booking: @valid_attrs
    assert redirected_to(conn) == booking_path(conn, :show, booking)
    assert Repo.get_by(Booking, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    booking = Repo.insert! %Booking{}
    conn = put conn, booking_path(conn, :update, booking), booking: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit booking"
  end

  test "deletes chosen resource", %{conn: conn} do
    booking = Repo.insert! %Booking{}
    conn = delete conn, booking_path(conn, :delete, booking)
    assert redirected_to(conn) == booking_path(conn, :index)
    refute Repo.get(Booking, booking.id)
  end
end
