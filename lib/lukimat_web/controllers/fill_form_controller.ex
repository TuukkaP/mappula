defmodule LukimatWeb.FillFormController do
  use LukimatWeb, :controller
  require IEx

  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Form
  alias Lukimat.Questionnaires.Answer
  alias Lukimat.Questionnaires.FormAnswer

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
    form_answer_attrs = build_form_answer(conn.assigns[:current_user], form, params)
    case Questionnaires.create_form_answer(form_answer_attrs) do
      {:ok, _value} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, value} ->
        render(conn, :new, form: form, answers: value)
    end
  end

  def completed(conn, _params) do
      conn
      |> put_flash(:info, "Answer created successfully.")
      |> redirect(to: page_path(conn, :index))
  end

  defp build_form_answer(current_user, form, %{"answers" => answers}) do
    answers = Enum.map(form.questions,
      fn(%{id: id, type: type}) ->
        %{question_id: id, answer: answers["#{id}"]["#{type}"]}
      end)

    %FormAnswer{
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
