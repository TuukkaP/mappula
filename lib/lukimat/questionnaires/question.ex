defmodule Lukimat.Questionnaires.Question do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Questionnaires.Question


  schema "questions" do
    field :content, :string
    field :correct_answer, :string
    field :level, :string
    field :type, :string
    field :audio, Lukimat.QuestionAudio.Type

    timestamps()
    has_many :answers, Lukimat.Questionnaires.Answer
    belongs_to :form, Lukimat.Questionnaires.Form
    has_many :choices, Lukimat.Questionnaires.Choice
  end

  @doc false
  def changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:content, :correct_answer, :type])
    |> cast_attachments(attrs, [:audio])
    |> assoc_constraint(:form)
    |> validate_required([:content, :correct_answer, :type])
    |> cast_assoc(:choices)
  end
end
