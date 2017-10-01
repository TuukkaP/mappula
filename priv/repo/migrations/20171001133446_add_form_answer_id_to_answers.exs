defmodule Lukimat.Repo.Migrations.AddFormAnswerIdToAnswers do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      add :form_answer_id, references(:form_answers)
    end
  end
end
