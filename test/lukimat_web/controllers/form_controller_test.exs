defmodule LukimatWeb.FormControllerTest do
  use LukimatWeb.ConnCase

  alias Lukimat.Questionnaire

  @create_attrs %{level: "some level", name: "some name"}
  @update_attrs %{level: "some updated level", name: "some updated name"}
  @invalid_attrs %{level: nil, name: nil}

  def fixture(:form) do
    {:ok, form} = Questionnaire.create_form(@create_attrs)
    form
  end

  describe "index" do
    test "lists all forms", %{conn: conn} do
      conn = get conn, form_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Forms"
    end
  end

  describe "new form" do
    test "renders form", %{conn: conn} do
      conn = get conn, form_path(conn, :new)
      assert html_response(conn, 200) =~ "New Form"
    end
  end

  describe "create form" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, form_path(conn, :create), form: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == form_path(conn, :show, id)

      conn = get conn, form_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Form"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, form_path(conn, :create), form: @invalid_attrs
      assert html_response(conn, 200) =~ "New Form"
    end
  end

  describe "edit form" do
    setup [:create_form]

    test "renders form for editing chosen form", %{conn: conn, form: form} do
      conn = get conn, form_path(conn, :edit, form)
      assert html_response(conn, 200) =~ "Edit Form"
    end
  end

  describe "update form" do
    setup [:create_form]

    test "redirects when data is valid", %{conn: conn, form: form} do
      conn = put conn, form_path(conn, :update, form), form: @update_attrs
      assert redirected_to(conn) == form_path(conn, :show, form)

      conn = get conn, form_path(conn, :show, form)
      assert html_response(conn, 200) =~ "some updated level"
    end

    test "renders errors when data is invalid", %{conn: conn, form: form} do
      conn = put conn, form_path(conn, :update, form), form: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Form"
    end
  end

  describe "delete form" do
    setup [:create_form]

    test "deletes chosen form", %{conn: conn, form: form} do
      conn = delete conn, form_path(conn, :delete, form)
      assert redirected_to(conn) == form_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, form_path(conn, :show, form)
      end
    end
  end

  defp create_form(_) do
    form = fixture(:form)
    {:ok, form: form}
  end
end
