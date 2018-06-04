defmodule FireEngine.Repo.Migrations.AddColorIndexToTags do
  use Ecto.Migration

  def change do

    alter table(:fe_tags) do
      add(:color_index, :string)
    end

  end
end
