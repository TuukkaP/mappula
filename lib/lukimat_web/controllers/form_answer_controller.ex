defmodule LukimatWeb.FormAnswerController do
  use LukimatWeb, :controller

  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.FormAnswer

  def index(conn, _params) do
    form_answers = Questionnaires.list_form_answers()
    render(conn, "index.html", form_answers: form_answers)
  end

  def new(conn, _params) do
    changeset = Questionnaires.change_form_answer(%FormAnswer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"form_answer" => form_answer_params}) do
    case Questionnaires.create_form_answer(form_answer_params) do
      {:ok, form_answer} ->
        conn
        |> put_flash(:info, "Form answer created successfully.")
        |> redirect(to: form_answer_path(conn, :show, form_answer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    form_answer = Questionnaires.get_form_answer!(id)
    render(conn, "show.html", form_answer: form_answer)
  end

  def delete(conn, %{"id" => id}) do
    form_answer = Questionnaires.get_form_answer!(id)
    {:ok, _form_answer} = Questionnaires.delete_form_answer(form_answer)

    conn
    |> put_flash(:info, "Form answer deleted successfully.")
    |> redirect(to: form_answer_path(conn, :index))
  end
end
