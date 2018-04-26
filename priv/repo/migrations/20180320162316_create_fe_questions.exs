defmodule FireEngine.Repo.Migrations.CreateFeQuestions do
  use Ecto.Migration

  def change do
    create table(:fe_questions) do
      add :content, :text
      add :type, :string
      add :points, :float
      add :negative_points, :float

      timestamps()
    end

  end
end
