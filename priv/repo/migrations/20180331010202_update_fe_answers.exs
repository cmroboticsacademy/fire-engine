defmodule FireEngine.Repo.Migrations.UpdateFeAnswers do
  use Ecto.Migration

  def change do
    alter table(:fe_answers) do
      add :question_id, references(:fe_questions)
    end

  end
end
