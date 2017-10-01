defmodule Lukimat.Questionnaires.FormAnswer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Accounts.User
  alias Lukimat.Repo
  alias Lukimat.Questionnaires.Form
  alias Lukimat.Questionnaires.FormAnswer
  alias Lukimat.Questionnaires.Answer


  schema "form_answers" do
    timestamps()
    belongs_to :user, User
    belongs_to :form, Form
    has_many :answers, Answer, on_delete: :delete_all
  end

  @doc false
  def changeset(%FormAnswer{} = form_answer, attrs) do
    form_answer
    |> Repo.preload([:user, :form])
    |> cast(attrs, [])
    |> cast_assoc(:answers, required: true)
    |> assoc_constraint(:user)
    |> assoc_constraint(:form)
  end
end
