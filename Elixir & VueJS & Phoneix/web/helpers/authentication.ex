defmodule Parko.Authentication do
    def check_credentials(conn, user, password) do
      Comeonin.Pbkdf2.check_pass(user, password)
    end
end