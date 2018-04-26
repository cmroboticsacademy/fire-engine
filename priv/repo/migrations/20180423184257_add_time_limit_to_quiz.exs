defmodule FireEngine.Repo.Migrations.AddTimeLimitToQuiz do
  use Ecto.Migration

  def change do
    alter table(:fe_quizzes) do
      add(:time_limit, :boolean, default: false)
      add(:time_limit_minutes, :integer)
    end
  end
end
