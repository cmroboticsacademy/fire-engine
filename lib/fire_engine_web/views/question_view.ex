defmodule FireEngineWeb.QuestionView do
  use FireEngineWeb, :view
  use Scrivener.HTML
  alias FireEngine.Assessments
  alias FireEngine.Assessments.Category
  alias FireEngine.Repo

  def list_categories() do
    Assessments.list_fe_categories |> Enum.map(&{&1.name,&1.id}) |> Enum.into([nil])
  end

  def get_category(nil), do: "Not Assigned"
  def get_category(category = %Category{}), do: category.name
  def get_category(id), do: get_category Repo.get(Assessments.Category,id)

  def question_tags(form,tags,selectedTags), do: multiple_select(form,:question_tags,tags,selected: selectedTags,  class: "form-control")
  def question_tags(form,tags,nil), do: multiple_select(form, :question_tags, tags, class: "form-control")


end
