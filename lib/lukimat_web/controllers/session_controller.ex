defmodule LukimatWeb.SessionController do
  use LukimatWeb, :controller
  require IEx
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Lukimat.Repo
  alias Lukimat.Accounts.User
  alias LukimatWeb.Guardian.Plug, as: GuardianPlug
  
  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    if invalid_params?(email, password) do
      render_error(conn, :unauthorized)
    else

      email = String.trim(email) |> String.downcase
      user = Repo.get_by(User, email: email)

      result = cond do
        user && checkpw(String.trim(password), user.encrypted_password) ->
          {:ok, login(conn, user)}
        true ->
          # simulate check password hash timing
          dummy_checkpw()
          {:error, :not_found, conn}
      end

      case result do
        {:ok, conn} ->
          conn =
            conn
            |> put_flash(:info, "You’re now logged in!")
            |> redirect(to: page_path(conn, :index))

        {:error, reason, conn} ->
          render_error(conn, reason)
      end
    end
  end

  def delete(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end

  defp logout(conn) do
    GuardianPlug.sign_out(conn)
  end

  defp login(conn, user) do
    conn
    |> GuardianPlug.sign_in(user)
  end

  defp blank?(string) do
    string == nil || string == ""
  end

  defp invalid_params?(email, password) do
    blank?(email) || blank?(password)
  end

  defp render_error(conn, _reason) do
    conn
    |> put_flash(:error, "Invalid email/password combination")
    |> render("new.html")
  end
end
