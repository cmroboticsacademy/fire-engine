defmodule FireEngine.Repo.Migrations.AddTimeWindowToQuiz do
  use Ecto.Migration

  def change do
    alter table(:fe_quizzes) do
      add(:time_window, :boolean)
    end
  end
end
