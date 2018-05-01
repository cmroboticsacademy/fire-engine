defmodule FireEngineWeb.QuestionView do
  use FireEngineWeb, :view
  alias FireEngine.Assessments
  alias FireEngine.Assessments.Category
  alias FireEngine.Repo

  def list_categories() do
    Assessments.list_fe_categories |> Enum.map(&{&1.name,&1.id}) |> Enum.into([nil])
  end

  def get_category(nil), do: "Not Assigned"
  def get_category(category = %Category{}), do: category.name
  def get_category(id), do: get_category Repo.get(Assessments.Category,id)


end
