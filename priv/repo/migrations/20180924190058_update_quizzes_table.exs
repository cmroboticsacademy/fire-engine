defmodule FireEngine.Repo.Migrations.UpdateQuizzesTable do
  use Ecto.Migration

  def change do
    alter table(:fe_quizzes) do
      add :show_answers, :boolean
    end
  end
end
