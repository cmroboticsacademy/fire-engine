defmodule FireEngine.Repo.Migrations.UpdateFeAnswersTable do
  use Ecto.Migration

  def change do
    alter table(:fe_answers) do
      modify :answer, :text
    end
  end
end
