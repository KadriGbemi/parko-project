defmodule Parko.PaymentAPIController do
    use Parko.Web, :controller
  
    alias Parko.Payment

    def show(conn, %{"id" => id}) do
        payment = Repo.get!(Payment, id)
        conn
        |>put_status(200)
        |>json(%{payment: payment})
    end
end