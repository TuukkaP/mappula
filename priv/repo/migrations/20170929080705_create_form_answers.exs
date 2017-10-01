defmodule Lukimat.Repo.Migrations.CreateFormAnswers do
  use Ecto.Migration

  def change do
    create table(:form_answers) do
      add :form_id, references(:forms, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:form_answers, [:form_id])
    create index(:form_answers, [:user_id])

    alter table(:answers) do
      remove :user_id
    end
  end
end
