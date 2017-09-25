defmodule Lukimat.Questionnaires.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Questionnaires.Question


  schema "questions" do
    field :content, :string
    field :correct_answer, :string
    field :level, :string
    field :type, :string
    field :audio, :string

    timestamps()
    has_many :answers, Lukimat.Questionnaires.Answer
    belongs_to :form, Lukimat.Questionnaires.Form
    has_many :choices, Lukimat.Questionnaires.Choice
  end

  @doc false
  def changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:form_id, :content, :correct_answer, :type, :audio])
    |> validate_required([:form_id, :content, :correct_answer, :type])
  end
end
