defmodule LukimatWeb.PageController do
  use LukimatWeb, :controller

  alias Lukimat.Questionnaires

  def index(conn, _params) do
    forms =
      Questionnaires.list_forms()
      |> Questionnaires.with_questions
    render(conn, "index.html", forms: forms)
  end
end
