defmodule LukimatWeb.UserControllerTest do
  use LukimatWeb.ConnCase

  alias Lukimat.Accounts

  @create_attrs %{class: "some class", email: "some email", encrypted_password: "some encrypted_password", first_name: "some first_name", language: "some language", last_name: "some last_name", role: "some role"}
  @update_attrs %{class: "some updated class", email: "some updated email", encrypted_password: "some updated encrypted_password", first_name: "some updated first_name", language: "some updated language", last_name: "some updated last_name", role: "some updated role"}
  @invalid_attrs %{class: nil, email: nil, encrypted_password: nil, first_name: nil, language: nil, last_name: nil, role: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)

      conn = get conn, user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200) =~ "some updated class"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert redirected_to(conn) == user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
