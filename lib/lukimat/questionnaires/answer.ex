defmodule Lukimat.Questionnaires.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Answer
  alias Lukimat.Questionnaires.Question
  require IEx


  schema "answers" do
    field :answer, :integer
    field :is_correct, :boolean, default: false

    timestamps()
    belongs_to :form_answer, Lukimat.Questionnaires.FormAnswer
    belongs_to :question, Lukimat.Questionnaires.Question
    has_one :user, through: [:form_answer, :user]
  end

  @doc false
  def changeset(%Answer{} = answer, attrs) do
    create_changeset(answer, attrs)
  end

  def create_changeset(%Answer{} = answer, attrs) do
    question =
      Questionnaires.get_question!(attrs[:question_id] || attrs["question_id"])
      |> Questionnaires.with_choices
    changeset(question, answer, attrs)
  end

  def update_changeset(%Answer{} = answer, attrs) do
    question =
      Questionnaires.get_question!(answer.question_id)
      |> Questionnaires.with_choices
    changeset(question, answer, attrs)
  end

  defp changeset(%Question{} = question, %Answer{} = answer, attrs) do
    answer
    |> Lukimat.Repo.preload(:question)
    |> cast(attrs, [:answer])
    |> validate_required([:answer])
    |> put_assoc(:question, question)
    |> put_is_correct(question)
    |> validate_answer_choice(question)
    |> validate_required([:answer, :is_correct])
  end

  defp put_is_correct(changeset, question) do
    case changeset do
      %Ecto.Changeset{changes: %{answer: answer}} ->
        correct? = "#{answer}" == question.correct_answer
        put_change(changeset, :is_correct, correct?)
      _ ->
        changeset
    end
  end

  defp validate_answer_choice(changeset, question) do
    if question.type == "multiple_choice" do

      validate_change(changeset, :answer, fn (:answer, answer) ->
        choice_found? =
          question.choices
          |> Enum.map(fn(choice) -> choice.id end)
          |> Enum.member?(answer)

        if choice_found? do
            []
        else
          [answer: "choice does not exist"]
        end
      end)

    else
      changeset
    end
  end
end
