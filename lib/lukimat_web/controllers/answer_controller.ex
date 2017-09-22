defmodule LukimatWeb.AnswerController do
  use LukimatWeb, :controller

  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Answer

  plug LukimatWeb.CurrentUser
  def index(conn, _params) do
    answers = Questionnaires.list_answers()
    render(conn, "index.html", answers: answers)
  end

  def new(conn, _params) do
    changeset = Questionnaires.change_answer(%Answer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"answer" => answer_params}) do
    case Questionnaires.create_answer(answer_params) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: answer_path(conn, :show, answer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Questionnaires.get_answer!(id)
    render(conn, "show.html", answer: answer)
  end

  def edit(conn, %{"id" => id}) do
    answer = Questionnaires.get_answer!(id)
    changeset = Questionnaires.change_answer(answer)
    render(conn, "edit.html", answer: answer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = Questionnaires.get_answer!(id)

    case Questionnaires.update_answer(answer, answer_params) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "Answer updated successfully.")
        |> redirect(to: answer_path(conn, :show, answer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", answer: answer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Questionnaires.get_answer!(id)
    {:ok, _answer} = Questionnaires.delete_answer(answer)

    conn
    |> put_flash(:info, "Answer deleted successfully.")
    |> redirect(to: answer_path(conn, :index))
  end
end
