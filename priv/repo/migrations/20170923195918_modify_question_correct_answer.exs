defmodule Lukimat.Repo.Migrations.ModifyQuestionCorrectAnswer do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      modify :correct_answer, :string
    end
  end
end
