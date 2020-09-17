defmodule FireEngine.Repo.Migrations.AddEncryptedPasswordToUsers do
  use Ecto.Migration

  def change do
    alter table(:fe_users) do
      add :encrypted_password, :string
    end

  end
end
