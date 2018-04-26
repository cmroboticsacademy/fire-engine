defmodule FireEngine.Repo.Migrations.CreateFeAttempts do
  use Ecto.Migration

  def change do
    create table(:fe_attempts) do
      add :open, :naive_datetime
      add :closes, :naive_datetime
      add :grade, :float
      add :closed, :boolean, default: false, null: false
      add :user_id, references(:fe_users, on_delete: :nothing)
      add :quiz_id, references(:fe_quizzes, on_delete: :nothing)

      timestamps()
    end

    create index(:fe_attempts, [:user_id])
    create index(:fe_attempts, [:quiz_id])
  end
end
