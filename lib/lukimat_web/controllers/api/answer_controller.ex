defmodule LukimatWeb.Api.AnswerController do
  use LukimatWeb, :controller

  alias Lukimat.Questionnaires

  def create(conn, %{"form_id" => form_id, "answers" => params}) do
    form = load_form(form_id)

    form_answer_attrs = build_form_answer(conn.assigns[:current_user], form, params)

    IO.inspect form_answer_attrs
    case Questionnaires.create_form_answer(form_answer_attrs) do
      {:ok, _value} ->
        conn
        |> render("create.json", answers: params)
      {:error, _value} ->
        conn
        |> put_status(500)
        |> render("create.json", answers: params)
    end
  end

  defp build_form_answer(current_user, form, answers) do
    answers = Enum.map(answers,
      fn(%{"question_id" => question_id, "answer" => answer}) ->
        %{question_id: question_id, answer: answer}
      end)

    %{
      user_id: current_user.id,
      form_id: form.id,
      answers: answers
    }
  end

  defp load_form(form_id) do
    Questionnaires.get_form!(form_id)
    |> Questionnaires.with_questions_and_choices
  end
end
