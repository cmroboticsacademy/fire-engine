defmodule FireEngine.Assessments.Response do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Assessments.Response


  schema "fe_responses" do
    field :score, :float
    field :attempt_id, :id
    field :question_id, :id
    field :answer_id, :id


    has_one :question, FireEngine.Assessments.Question
    has_one :answer, FireEngine.Assessments.Answer

    timestamps(usec: false)
  end

  @doc false
  def changeset(%Response{} = response, attrs) do
    response
    |> cast(attrs, [:score, :question_id, :answer_id, :attempt_id])
  end
end
