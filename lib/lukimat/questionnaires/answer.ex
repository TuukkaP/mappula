defmodule Lukimat.Questionnaires.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Questionnaires.Answer


  schema "answers" do
    field :answer, :string
    field :is_correct, :boolean, default: false

    timestamps()
    belongs_to :user, Lukimat.Accounts.User
    belongs_to :question, Lukimat.Questionnaires.Question
  end

  @doc false
  def changeset(%Answer{} = answer, attrs) do
    answer
    |> cast(attrs, [:answer, :is_correct])
    |> validate_required([:answer, :is_correct])
  end
end
