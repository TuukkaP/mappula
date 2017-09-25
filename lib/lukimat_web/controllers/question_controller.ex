defmodule LukimatWeb.QuestionController do
  use LukimatWeb, :controller

  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Question

  def index(conn, _params) do
    questions = 
      Questionnaires.list_questions()
      |> Questionnaires.with_choices
    render(conn, "index.html", questions: questions)
  end

  def new(conn, _params) do
    changeset = Questionnaires.change_question(%Question{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"question" => question_params}) do
    case Questionnaires.create_question(question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question created successfully.")
        |> redirect(to: question_path(conn, :show, question))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Questionnaires.get_question!(id)
    render(conn, "show.html", question: question)
  end

  def edit(conn, %{"id" => id}) do
    question = Questionnaires.get_question!(id)
    changeset = Questionnaires.change_question(question)
    render(conn, "edit.html", question: question, changeset: changeset)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Questionnaires.get_question!(id)

    case Questionnaires.update_question(question, question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question updated successfully.")
        |> redirect(to: question_path(conn, :show, question))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", question: question, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Questionnaires.get_question!(id)
    {:ok, _question} = Questionnaires.delete_question(question)

    conn
    |> put_flash(:info, "Question deleted successfully.")
    |> redirect(to: question_path(conn, :index))
  end
end
