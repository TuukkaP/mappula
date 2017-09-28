defmodule LukimatWeb.ChoiceControllerTest do
  use LukimatWeb.ConnCase

  alias Lukimat.Questionnaires

  @create_attrs %{content: "some content", url: "some url"}
  @update_attrs %{content: "some updated content", url: "some updated url"}
  @invalid_attrs %{content: nil, url: nil}

  setup context do
    current_user = insert(:user)
    conn = sign_in(context[:conn], current_user)
    {:ok, conn: conn, current_user: current_user, choice: insert(:choice)}
  end

  describe "index" do
    test "lists all choices", %{conn: conn} do
      conn = get conn, choice_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Choices"
    end
  end

  describe "new choice" do
    test "renders form", %{conn: conn} do
      conn = get conn, choice_path(conn, :new)
      assert html_response(conn, 200) =~ "New Choice"
    end
  end

  describe "create choice" do
    test "redirects to show when data is valid", %{conn: conn, choice: choice} do
      attrs = Map.merge(@create_attrs, %{question_id: insert(:question).id})
      conn = post conn, choice_path(conn, :create), choice: attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == choice_path(conn, :show, id)

      IO.inspect conn
      conn = get conn, choice_path(conn, :show, id)
      IO.inspect conn
      IO.inspect Questionnaires.list_choices()
      assert html_response(conn, 200) =~ "Show Choice"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, choice_path(conn, :create), choice: @invalid_attrs
      assert html_response(conn, 200) =~ "New Choice"
    end
  end

  describe "edit choice" do
    test "renders form for editing chosen choice", %{conn: conn, choice: choice} do
      conn = get conn, choice_path(conn, :edit, choice)
      assert html_response(conn, 200) =~ "Edit Choice"
    end
  end

  describe "update choice" do
    test "redirects when data is valid", %{conn: conn, choice: choice} do
      conn = put conn, choice_path(conn, :update, choice), choice: @update_attrs
      assert redirected_to(conn) == choice_path(conn, :show, choice)

      conn = get conn, choice_path(conn, :show, choice)
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, choice: choice} do
      conn = put conn, choice_path(conn, :update, choice), choice: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Choice"
    end
  end

  describe "delete choice" do
    test "deletes chosen choice", %{conn: conn, choice: choice} do
      conn = delete conn, choice_path(conn, :delete, choice)
      assert redirected_to(conn) == choice_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, choice_path(conn, :show, choice)
      end
    end
  end
end
