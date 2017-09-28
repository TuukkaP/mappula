defmodule LukimatWeb.AuthErrorHandlerController do
  use LukimatWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    IO.inspect get_format(conn)
    case get_format(conn) do
      "html" ->
        conn
        |> put_flash(:error, "You must be signed in to access that page.")
        |> redirect(to: session_path(conn, :new))
      _ ->
        body = Poison.encode!(%{message: to_string(type)})
        send_resp(conn, 401, body)
    end
  end
end
