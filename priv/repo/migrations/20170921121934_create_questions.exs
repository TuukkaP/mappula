defmodule Lukimat.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :level, :string
      add :content, :string
      add :correct_answer, :integer
      add :choices, :map

      timestamps()
    end

  end
end
