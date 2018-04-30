defmodule FireEngine.Repo.Migrations.AddCategoryToQuestions do
  use Ecto.Migration

  def change do

    alter table(:fe_questions) do
      add :category_id, references(:fe_categories)
    end

  end
end
