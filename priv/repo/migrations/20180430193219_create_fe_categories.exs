defmodule FireEngine.Repo.Migrations.CreateFeCategories do
  use Ecto.Migration

  def change do
    create table(:fe_categories) do
      add :name, :string
      add :parent_id, :integer

      timestamps()
    end

  end
end
