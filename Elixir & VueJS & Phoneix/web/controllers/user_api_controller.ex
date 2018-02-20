defmodule Parko.UserAPIController do
    use Parko.Web, :controller
  
    alias Parko.User

    def create(conn,  user_params) do
      changeset = User.changeset(%User{}, user_params)
  
      case Repo.insert(changeset) do
        {:ok, user} ->
          conn
          |> put_status(201)
          |> json(%{msg: "User saved"})
          {:error, _} ->
            conn
            |> put_status(400)
            |> json(%{message: "Bad credentials"})
    end
end
end