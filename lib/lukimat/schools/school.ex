defmodule Lukimat.Schools.School do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Schools.School


  schema "schools" do
    field :name, :string

    timestamps()
    has_many :users, Lukimat.Accounts.User
  end

  @doc false
  def changeset(%School{} = school, attrs) do
    school
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
