defmodule Lukimat.Repo.Migrations.CreateChoices do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      remove :choices
    end

    create table(:choices) do
      add :content, :string
      add :url, :string
      add :question_id, references(:questions, on_delete: :nothing)

      timestamps()
    end

    create index(:choices, [:question_id])
  end
end
