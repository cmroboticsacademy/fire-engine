defmodule FireEngine.Repo.Migrations.CreateFeAnswers do
  use Ecto.Migration

  def change do
    create table(:fe_answers) do
      add :answer, :string
      add :correct, :boolean, default: false, null: false

      timestamps()
    end

  end
end
