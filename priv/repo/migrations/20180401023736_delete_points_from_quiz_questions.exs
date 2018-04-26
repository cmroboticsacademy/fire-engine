defmodule FireEngine.Repo.Migrations.DeletePointsFromQuizQuestions do
  use Ecto.Migration

  def change do
    alter table(:fe_quiz_questions) do
      remove(:negative_points)
      remove(:points)
    end

  end
end
