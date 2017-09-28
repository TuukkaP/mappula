defmodule LukimatWeb.Api.AnswerController do
  use LukimatWeb, :controller

  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Answer
  alias Lukimat.Accounts.User

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
