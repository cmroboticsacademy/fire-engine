defmodule FireEngine.Repo.Migrations.AddMoodleQuestionAndAnswerIdToQuestionAnswers do
  use Ecto.Migration

  def change do
    alter table(:fe_quizzes) do
      add(:moodle_quiz_id, :integer)
    end

    alter table(:fe_questions) do
      add(:moodle_question_id, :integer)
    end

    alter table(:fe_answers) do
      add(:moodle_question_id, :integer)
      add(:moodle_answer_id, :integer)
    end

    alter table(:fe_quiz_questions) do
      add(:moodle_quiz_id, :integer)
      add(:moodle_question_id, :integer)
    end
  end
end
