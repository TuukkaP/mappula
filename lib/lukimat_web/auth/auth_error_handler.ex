defmodule LukimatWeb.AuthErrorHandlerController do
  use LukimatWeb, :controller

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, "You must be signed in to access that page.")
    |> redirect(to: session_path(conn, :new))
  end
end
