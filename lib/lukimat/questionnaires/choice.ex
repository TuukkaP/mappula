defmodule Lukimat.Questionnaires.Choice do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Questionnaires.Choice


  schema "choices" do
    field :content, :string
    field :url, :string
    field :image, Lukimat.ChoiceImage.Type

    timestamps()
    belongs_to :question, Lukimat.Questionnaires.Question
  end

  @doc false
  def changeset(%Choice{} = choice, attrs) do
    choice
    |> cast(attrs, [:content, :url, :question_id])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:content, :question_id])
  end
end
