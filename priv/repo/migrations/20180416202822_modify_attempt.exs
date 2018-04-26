defmodule FireEngine.Repo.Migrations.ModifyAttempt do
  use Ecto.Migration

  def change do
    alter table(:fe_attempts) do
      remove(:grade)
      add(:point_percent, :float)
      add(:point_total, :float)
      add(:points_available, :float)
    end
  end
end
