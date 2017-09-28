defmodule Lukimat.Questionnaires.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Questionnaires
  alias Lukimat.Questionnaires.Answer
  alias Lukimat.Questionnaires.Question
  require IEx


  schema "answers" do
    field :answer, :string
    field :is_correct, :boolean, default: false

    timestamps()
    belongs_to :user, Lukimat.Accounts.User
    belongs_to :question, Lukimat.Questionnaires.Question
  end

  @doc false
  def create_changeset(%Answer{} = answer, attrs) do
    question = Questionnaires.get_question!(attrs.question_id)
    changeset(question, answer, attrs)
  end

  def update_changeset(%Answer{} = answer, attrs) do
    question = Questionnaires.get_question!(answer.question_id)
    changeset(question, answer, attrs)
  end

  defp changeset(%Question{} = question, %Answer{} = answer, attrs) do
    answer
    |> Lukimat.Repo.preload(:question)
    |> cast(attrs, [:answer])
    |> validate_required([:answer])
    |> put_assoc(:question, question)
    |> put_is_correct(question)
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

end
