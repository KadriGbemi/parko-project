defmodule Parko.PageController do
  use Parko.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
