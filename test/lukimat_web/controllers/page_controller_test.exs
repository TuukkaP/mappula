defmodule LukimatWeb.PageControllerTest do
  use LukimatWeb.ConnCase

  setup context do
    current_user = insert(:user)
    conn = sign_in(context[:conn], current_user)
    {:ok, conn: conn, current_user: current_user}
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
