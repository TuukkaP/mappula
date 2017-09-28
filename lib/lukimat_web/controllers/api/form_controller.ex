defmodule LukimatWeb.Api.FormController do
  use LukimatWeb, :controller

  alias Lukimat.Questionnaires

  def show(conn, %{"id" => id}) do
    form =
      Questionnaires.get_form!(id)
      |> Questionnaires.with_questions_and_choices
    render(conn, "show.json", form: form)
  end
end
