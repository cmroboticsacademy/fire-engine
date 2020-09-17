defmodule FireEngineWeb.CategoryView do
  use FireEngineWeb, :view
  use Scrivener.HTML
  alias FireEngine.Assessments
  alias FireEngine.Assessments.Category
  alias FireEngine.Repo

  def list_parents() do
    Assessments.list_fe_categories |> Enum.map(&{&1.name,&1.id}) |> Enum.into([nil])
  end


  def get_parent(nil), do: "Not Assigned"
  def get_parent(category = %Category{}), do: category.name
  def get_parent(id), do: get_parent Repo.get(Assessments.Category,id)

end
