defmodule LukimatWeb.Api.AnswerView do
  use LukimatWeb, :view
  import LukimatWeb.Api.Serializer

  def render("create.json", %{answers: answers}) do
    answers_to_json(answers)
  end
end
