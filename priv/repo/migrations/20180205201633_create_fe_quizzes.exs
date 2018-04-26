defmodule FireEngine.Repo.Migrations.CreateFeQuizzes do
  use Ecto.Migration

  def change do
    create table(:fe_quizzes) do
      add :name, :string
      add :description, :text
      add :attempts_allowed, :integer
      add :randomize_questions, :boolean, default: false, null: false
      add :single_attempt_per_question, :boolean, default: false, null: false
      add :real_time_feedback, :boolean, default: false, null: false
      add :show_correct_answer, :boolean, default: false, null: false
      add :questions_per_page, :integer
      add :time_open, :naive_datetime
      add :time_closed, :naive_datetime

      timestamps()
    end

  end
end
