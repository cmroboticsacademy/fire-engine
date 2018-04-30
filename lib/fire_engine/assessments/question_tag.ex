defmodule FireEngine.Assessments.QuestionTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Assessments.QuestionTag


  schema "fe_question_tags" do
    field :question_id, :integer
    field :tag_id, :integer

    timestamps(usec: false)
  end

  @doc false
  def changeset(%QuestionTag{} = question_tag, attrs) do
    question_tag
    |> cast(attrs, [:question_id, :tag_id])
    |> validate_required([:question_id, :tag_id])
  end
end
