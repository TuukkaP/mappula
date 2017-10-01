defmodule LukimatWeb.FormAnswerControllerTest do
  use LukimatWeb.ConnCase

  alias Lukimat.Questionnaires
  alias Lukimat.Accounts

  @user_attrs %{class: "some class", email: "test@example.org", password: "password", password_confirmation: "password", first_name: "some first_name", language: "some language", last_name: "some last_name", role: "some role"}
  @form_attrs %{name: "Test form", level: "easy", questions: [%{content: "why?", correct_answer: "1", type: "multiple_choice"}]}
  @update_attrs %{}
  @invalid_attrs %{}

  setup context do
    current_user = insert(:user)
    conn = sign_in(context[:conn], current_user)
    {:ok, conn: conn, current_user: current_user, choice: insert(:choice)}
  end

  describe "index" do
    test "lists all form_answers", %{conn: conn} do
      conn = get conn, form_answer_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Form answers"
    end
  end

  describe "new form_answer" do
    test "renders form", %{conn: conn} do
      conn = get conn, form_answer_path(conn, :new)
      assert html_response(conn, 200) =~ "New Form answer"
    end
  end

  describe "create form_answer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, form_answer_path(conn, :create), form_answer: form_answer_params()

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == form_answer_path(conn, :show, id)

      conn = get conn, form_answer_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Form answer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, form_answer_path(conn, :create), form_answer: @invalid_attrs
      assert html_response(conn, 200) =~ "New Form answer"
    end
  end

  describe "delete form_answer" do
    setup [:create_form_answer]

    test "deletes chosen form_answer", %{conn: conn, form_answer: form_answer} do
      conn = delete conn, form_answer_path(conn, :delete, form_answer)
      assert redirected_to(conn) == form_answer_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, form_answer_path(conn, :show, form_answer)
      end
    end
  end

  defp create_form_answer(_) do
    params = form_answer_params()
    {:ok, form_answer} = Questionnaires.create_form_answer(params)
    {:ok, form_answer: form_answer, params: params}
  end

  defp form_answer_params() do
    {:ok, form} = Questionnaires.create_form(@form_attrs)
    {:ok, user} = Accounts.create_user(@user_attrs)
    question = form.questions |> List.first
    %{
      form_id: form.id, user_id: user.id,
      answers: [%{answer: 1, question_id: question.id}]
    }
  end
end
