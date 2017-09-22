defmodule Lukimat.Repo.Migrations.CreateForms do
  use Ecto.Migration

  def change do
    create table(:forms) do
      add :level, :string
      add :name, :string

      timestamps()
    end

  end
end
