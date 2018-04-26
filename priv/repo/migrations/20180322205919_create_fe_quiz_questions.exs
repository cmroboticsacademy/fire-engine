defmodule FireEngine.Repo.Migrations.CreateFeQuizQuestions do
  use Ecto.Migration

  def change do
    create table(:fe_quiz_questions) do
      add :quiz_id, references(:fe_quizzes)
      add :question_id, references(:fe_questions)
      add :points, :float
      add :negative_points, :float

      timestamps()
    end

  end
end
