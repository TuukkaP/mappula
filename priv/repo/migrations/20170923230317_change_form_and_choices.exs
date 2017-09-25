defmodule Lukimat.Repo.Migrations.AddFilesToChoicesAndQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :audio, :string
    end

    alter table(:choices) do
      add :image, :string
    end
  end
end
