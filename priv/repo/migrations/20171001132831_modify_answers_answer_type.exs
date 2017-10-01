defmodule Lukimat.Repo.Migrations.ModifyAnswersAnswerType do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      remove :answer
      add :answer, :integer
    end
  end
end
