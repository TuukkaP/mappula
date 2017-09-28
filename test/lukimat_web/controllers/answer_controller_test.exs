defmodule LukimatWeb.AnswerControllerTest do
  use LukimatWeb.ConnCase

  alias Lukimat.Questionnaires

  @create_attrs %{answer: 42, is_correct: true}
  @update_attrs %{answer: 43, is_correct: false}
  @invalid_attrs %{answer: nil, is_correct: nil}

  setup context do
    current_user = insert(:user)
    conn = sign_in(context[:conn], current_user)
    {:ok, conn: conn, current_user: current_user}
  end

  def fixture(:answer) do
    insert(:answer)
  end

  describe "index" do
    test "lists all answers", %{conn: conn} do
      conn = get conn, answer_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Answers"
    end
  end

  describe "new answer" do
    test "renders form", %{conn: conn} do
      conn = get conn, answer_path(conn, :new)
      assert html_response(conn, 200) =~ "New Answer"
    end
  end

  describe "create answer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, answer_path(conn, :create), answer: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == answer_path(conn, :show, id)

      conn = get conn, answer_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Answer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, answer_path(conn, :create), answer: @invalid_attrs
      assert html_response(conn, 200) =~ "New Answer"
    end
  end

  describe "edit answer" do
    setup [:create_answer]

    test "renders form for editing chosen answer", %{conn: conn, answer: answer} do
      conn = get conn, answer_path(conn, :edit, answer)
      assert html_response(conn, 200) =~ "Edit Answer"
    end
  end

  describe "update answer" do
    setup [:create_answer]

    test "redirects when data is valid", %{conn: conn, answer: answer} do
      conn = put conn, answer_path(conn, :update, answer), answer: @update_attrs
      assert redirected_to(conn) == answer_path(conn, :show, answer)

      conn = get conn, answer_path(conn, :show, answer)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, answer: answer} do
      conn = put conn, answer_path(conn, :update, answer), answer: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Answer"
    end
  end

  describe "delete answer" do
    setup [:create_answer]

    test "deletes chosen answer", %{conn: conn, answer: answer} do
      conn = delete conn, answer_path(conn, :delete, answer)
      assert redirected_to(conn) == answer_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, answer_path(conn, :show, answer)
      end
    end
  end

  defp create_answer(_) do
    answer = fixture(:answer)
    {:ok, answer: answer}
  end
end
