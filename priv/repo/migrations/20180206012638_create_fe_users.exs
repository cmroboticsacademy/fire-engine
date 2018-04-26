defmodule FireEngine.Repo.Migrations.CreateFeUsers do
  use Ecto.Migration

  def change do
    create table(:fe_users) do
      add :username, :string
      add :email, :string

      timestamps()
    end

  end
end
