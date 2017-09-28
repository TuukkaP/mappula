defmodule Lukimat.Questionnaires.Form do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Questionnaires.Form

  @derive {Poison.Encoder, except: [:__meta__]}
  schema "forms" do
    field :level, :string
    field :name, :string

    timestamps()

    has_many :questions, Lukimat.Questionnaires.Question
  end

  @doc false
  def changeset(%Form{} = form, attrs) do
    form
    |> cast(attrs, [:level, :name])
    |> validate_required([:level, :name])
  end
end
