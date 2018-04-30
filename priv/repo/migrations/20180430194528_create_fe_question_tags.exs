defmodule FireEngine.Repo.Migrations.CreateFeQuestionTags do
  use Ecto.Migration

  def change do
    create table(:fe_question_tags) do
      add :question_id, references(:fe_questions, on_delete: :nothing)
      add :tag_id, references(:fe_tags, on_delete: :nothing)

      timestamps()
    end

    create index(:fe_question_tags, [:question_id])
    create index(:fe_question_tags, [:tag_id])
  end
end
