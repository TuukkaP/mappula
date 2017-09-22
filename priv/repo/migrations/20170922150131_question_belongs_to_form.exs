defmodule Lukimat.Repo.Migrations.QuestionBelongsToForm do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :form_id, references(:forms)
    end
  end
end
