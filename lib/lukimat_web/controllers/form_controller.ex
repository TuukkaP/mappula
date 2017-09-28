defmodule LukimatWeb.FormController do
  use LukimatWeb, :controller

  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Form

  def index(conn, _params) do
    forms =
      Questionnaires.list_forms()
      |> Questionnaires.with_questions_and_choices
    render(conn, "index.html", forms: forms)
  end

  def new(conn, _params) do
    changeset = Questionnaires.change_form(%Form{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"form" => form_params}) do
    case Questionnaires.create_form(form_params) do
      {:ok, form} ->
        conn
        |> put_flash(:info, "Form created successfully.")
        |> redirect(to: form_path(conn, :show, form))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    form = Questionnaires.get_form!(id)
    render(conn, "show.html", form: form)
  end

  def edit(conn, %{"id" => id}) do
    form = Questionnaires.get_form!(id)
    changeset = Questionnaires.change_form(form)
    render(conn, "edit.html", form: form, changeset: changeset)
  end

  def update(conn, %{"id" => id, "form" => form_params}) do
    form = Questionnaires.get_form!(id)

    case Questionnaires.update_form(form, form_params) do
      {:ok, form} ->
        conn
        |> put_flash(:info, "Form updated successfully.")
        |> redirect(to: form_path(conn, :show, form))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", form: form, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    form = Questionnaires.get_form!(id)
    {:ok, _form} = Questionnaires.delete_form(form)

    conn
    |> put_flash(:info, "Form deleted successfully.")
    |> redirect(to: form_path(conn, :index))
  end
end
