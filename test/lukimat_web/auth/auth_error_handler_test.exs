defmodule LukimatWeb.AuthErrorHandlerControllerTest do
  use LukimatWeb.ConnCase

  alias LukimatWeb.AuthErrorHandlerController

  describe("#auth_error") do
    test "sends 401 resp with {message: <type>} json as body", %{conn: conn} do
      conn = get conn, api_form_path(conn, :show, 1)

      assert conn.status == 401
      assert conn.resp_body == Poison.encode!(%{message: "unauthenticated"})
    end

  end
end
