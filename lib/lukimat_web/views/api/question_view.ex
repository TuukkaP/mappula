defmodule LukimatWeb.Api.QuestionView do
  use LukimatWeb, :view
  import LukimatWeb.Api.Serializer

  def render("index.json", %{questions: questions}) do
    questions_to_json(questions)
  end
end
