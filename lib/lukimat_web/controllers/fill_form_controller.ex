defmodule LukimatWeb.FillFormController do
  use LukimatWeb, :controller
  require IEx

  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Form
  alias Lukimat.Questionnaires.Answer

  def index(conn, _params) do
    forms =
      Questionnaires.list_forms()
      |> Questionnaires.with_questions
    render(conn, "index.html", forms: forms)
  end

  def new(conn, %{"form_id" => form_id} = params) do
    form =  load_form(form_id)
    render(conn, :new, form: form)
  end

  def create(conn, %{"form_id" => form_id} = params) do
    form = load_form(form_id)
    IO.inspect params
    answers = build_answers(conn.assigns[:current_user], form, params)
    result = Lukimat.Repo.transaction(fn ->
      #Enum.each(answers, fn(answer) -> Lukimat.Repo.insert!(answer) end)
      Enum.each(answers, fn(answer) -> Questionnaires.create_answer(answer) end)
    end )
    case result do
      {:ok, _value} ->
        IO.inspect _value
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: answer_path(conn, :index))
      {:error, _value} ->
        IO.inspect _value
        render(conn, :new, form: form, answers: answers)
    end
  end

  defp build_answers(current_user, form, %{"answers" => answers}) do
    Enum.map(form.questions,
      fn(%{id: id, type: type, correct_answer: correct_answer}) ->
        params_answer = answers["#{id}"]["#{type}"]
        %{
          user_id: current_user.id,
          question_id: id,
          answer: params_answer,
        }
      end)
  end

  defp load_form(form_id) do
    Questionnaires.get_form!(form_id)
    |> Questionnaires.with_questions_and_choices
  end

  defp correct_answer?(expected, actual) do
    String.downcase(expected) == String.downcase(actual)
  end
end
