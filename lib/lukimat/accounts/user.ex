defmodule Lukimat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lukimat.Accounts.User


  schema "users" do
    field :class, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :encrypted_password, :string
    field :first_name, :string
    field :language, :string
    field :last_name, :string
    field :role, :string

    timestamps()
    has_many :answers, Lukimat.Questionnaires.Answer
    belongs_to :school, Lukimat.Schools.School
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :language, :password, :password_confirmation, :class, :role, :school_id])
    |> validate_required([:first_name, :last_name, :email, :language, :class, :role])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "does not match password")
  end


  defp password_and_confirmation_match(changeset) do
    validate_change(changeset, :password, fn _, url ->
      case  do
        true -> []
        false -> [{field, options[:message] || "Unexpected URL"}]
      end
    end)

  end

end
