defmodule FireEngine.Repo.Migrations.ModifyQuiz do
  use Ecto.Migration

  def change do
    alter table(:fe_quizzes) do
      remove(:real_time_feedback)
      remove(:show_correct_answer)
      remove(:single_attempt_per_question)
    end
  end
end
