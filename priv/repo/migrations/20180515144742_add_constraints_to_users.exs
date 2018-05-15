defmodule FireEngine.Repo.Migrations.AddConstraintsToUsers do
  use Ecto.Migration

  def change do
    create unique_index(:fe_users, [:email,:username])
  end
end
