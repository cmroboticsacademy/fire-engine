defmodule FireEngine.Repo.Migrations.CreateFeRoles do
  use Ecto.Migration

  def change do
    create table(:fe_roles) do
      add :user_id, references(:fe_users, on_delete: :nothing)
      add :name, :string

      timestamps()
    end

    create index(:fe_roles, [:user_id])
  end
end
