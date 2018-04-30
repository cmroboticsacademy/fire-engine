defmodule FireEngine.Repo.Migrations.CreateFeTags do
  use Ecto.Migration

  def change do
    create table(:fe_tags) do
      add :name, :string

      timestamps()
    end

  end
end
