defmodule Parko.PageControllerTest do
  use Parko.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello Parko"
  end
end
