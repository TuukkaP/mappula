defmodule LukimatWeb.Api.QuestionController do
  use LukimatWeb, :controller
  alias LukimatWeb.Guardian.Plug, as: GPlug

  alias Lukimat.Questionnaires

  def index(conn, %{"form_id" => form_id}) do
    form =
      Questionnaires.get_form!(form_id)
      |> Questionnaires.with_questions_and_choices
    render(conn, "index.json", questions: form.questions)
  end
end
