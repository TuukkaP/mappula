defmodule LukimatWeb.Api.QuestionController do
  use LukimatWeb, :controller

  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Answer
  alias Lukimat.Accounts.User

  def index(conn, %{"form_id" => form_id}) do
    form =
      Questionnaires.get_form!(form_id)
      |> Questionnaires.with_questions_and_choices
    render(conn, "index.json", questions: form.questions)
  end

  def create(conn, %{"_json" => params}) do
    answers = build_answers(conn.assigns[:current_user], params)
    result = Lukimat.Repo.transaction(fn ->
      Enum.each(answers, fn(answer) -> Questionnaires.create_answer(answer) end)
    end )
    case result do
      {:ok, _value} ->
        conn
        |> render("create.json", answers: params)
      {:error, _value} ->
        conn
        |> render("create.json", answers: params)
    end
  end

  defp build_answers(%User{} = current_user, params) do
    IO.inspect params
    Enum.map(params,
      fn(%{"question_id" => question_id, "answer" => answer}) ->
        %{
          user_id: current_user.id,
          question_id: question_id,
          answer: String.trim("#{answer}"),
        }
      end)
  end
end
