defmodule Lukimat.Repo.Migrations.ChangeAnswerContentType do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      modify :answer, :string
    end
  end
end
