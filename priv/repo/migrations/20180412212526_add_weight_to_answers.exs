defmodule FireEngine.Repo.Migrations.AddWeightToAnswers do
  use Ecto.Migration

  def change do

    alter table(:fe_answers) do
      add(:weight, :float)
      remove(:correct)
    end

  end
end
