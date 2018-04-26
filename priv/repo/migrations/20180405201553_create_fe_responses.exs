defmodule FireEngine.Repo.Migrations.CreateFeResponses do
  use Ecto.Migration

  def change do
    create table(:fe_responses) do
      add :score, :float
      add :attempt_id, references(:fe_attempts, on_delete: :nothing)
      add :question_id, references(:fe_questions, on_delete: :nothing)
      add :answer_id, references(:fe_answers, on_delete: :nothing)

      timestamps()
    end

    create index(:fe_responses, [:attempt_id])
    create index(:fe_responses, [:question_id])
    create index(:fe_responses, [:answer_id])
  end
end
