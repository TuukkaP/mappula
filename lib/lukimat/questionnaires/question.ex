defmodule Lukimat.Questionnaires.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Questionnaires.Question


  schema "questions" do
    field :choices, :map
    field :content, :string
    field :correct_answer, :integer
    field :level, :string

    timestamps()
    has_many :answers, Lukimat.Questionnaires.Answer
  end

  @doc false
  def changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:level, :content, :correct_answer, :choices])
    |> validate_required([:level, :content, :correct_answer, :choices])
  end
end
