defmodule LukimatWeb.Api.QuestionView do
  use LukimatWeb, :view
  import LukimatWeb.Api.Serializer

  def render("index.json", %{questions: questions}) do
    questions
    |> Enum.sort_by(&(&1.id))
    |> questions_to_json
  end
end
