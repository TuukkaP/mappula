defmodule LukimatWeb.ChoiceController do
  use LukimatWeb, :controller
  require IEx

  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Choice

  def index(conn, _params) do
    choices = Questionnaires.list_choices()
    render(conn, "index.html", choices: choices)
  end

  def new(conn, _params) do
    changeset = Questionnaires.change_choice(%Choice{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"choice" => choice_params}) do
    #{upload, choice_params} = Map.pop(choice_params, "image") 
    case Questionnaires.create_choice(choice_params) do
      {:ok, choice} ->
        conn
        |> put_flash(:info, "Choice created successfully.")
        |> redirect(to: choice_path(conn, :show, choice))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    choice = Questionnaires.get_choice!(id)
    render(conn, "show.html", choice: choice)
  end

  def edit(conn, %{"id" => id}) do
    choice = Questionnaires.get_choice!(id)
    changeset = Questionnaires.change_choice(choice)
    render(conn, "edit.html", choice: choice, changeset: changeset)
  end

  def update(conn, %{"id" => id, "choice" => choice_params}) do
    choice = Questionnaires.get_choice!(id)

    case Questionnaires.update_choice(choice, choice_params) do
      {:ok, choice} ->
        conn
        |> put_flash(:info, "Choice updated successfully.")
        |> redirect(to: choice_path(conn, :show, choice))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", choice: choice, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    choice = Questionnaires.get_choice!(id)
    {:ok, _choice} = Questionnaires.delete_choice(choice)

    conn
    |> put_flash(:info, "Choice deleted successfully.")
    |> redirect(to: choice_path(conn, :index))
  end
end
