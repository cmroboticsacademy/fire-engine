defmodule FireEngine.Repo.Migrations.AddStartTimeToAttempt do
  use Ecto.Migration

  def change do
    alter table(:fe_attempts) do
      add(:start_time, :naive_datetime)
    end
  end
end
