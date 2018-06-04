defmodule FireEngine.Assessments.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Assessments.Tag


  schema "fe_tags" do
    field :name, :string
    field :color_index, :string
    many_to_many :questions, FireEngine.Assessments.Question, join_through: "fe_question_tags", on_delete: :delete_all, on_replace: :delete

    timestamps(usec: false)
  end

  @doc false
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, [:name, :color_index])
    |> validate_required([:name, :color_index])
  end
end
