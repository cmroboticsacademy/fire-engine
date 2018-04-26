defmodule FireEngine.Repo.Migrations.AddFieldsToQuiz do
  use Ecto.Migration

  def change do

    alter table(:fe_quizzes) do
      add :color_index, :string
      add :auto_submit, :boolean
    end

  end
end
