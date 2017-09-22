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
    |> validate_required([:email, :language, :class, :role])
    |> validate_format(:email, ~r/@/)
    |> downcase_email
    |> validate_length(:password, min: 6, max: 32)
    |> validate_confirmation(:password, message: "does not match password")
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end

  defp downcase_email(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{email: email}} ->
        put_change(changeset, :email, String.downcase(email))
      _ ->
        changeset
    end
  end
end
