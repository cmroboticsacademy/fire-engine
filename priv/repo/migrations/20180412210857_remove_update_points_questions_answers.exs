defmodule FireEngine.Repo.Migrations.RemoveUpdatePointsQuestionsAnswers do
  use Ecto.Migration

  def change do

    alter table(:fe_questions) do
      remove(:negative_points)
    end



  end
end
