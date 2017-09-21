defmodule Lukimat.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string, null: false
      add :language, :string
      add :encrypted_password, :string
      add :class, :string
      add :role, :string
      add :school_id, references(:schools, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:school_id])
    create unique_index(:users, [:email])
  end
end
