defmodule LukimatWeb.Api.FormView do
  use LukimatWeb, :view
  import LukimatWeb.Api.Serializer

  def render("show.json", %{form: form}) do
    form_to_json(form)
  end
end
