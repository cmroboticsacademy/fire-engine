defmodule FireEngine.Assessments.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Assessments.Answer


  schema "fe_answers" do
    field :answer, :string
    field :weight, :float

    belongs_to :question ,FireEngine.Assessments.Question
    has_many :responses, FireEngine.Assessments.Response, on_delete: :delete_all

    timestamps(usec: false)
  end

  @doc false
  def changeset(%Answer{} = answer, attrs) do
    answer
    |> cast(attrs, [:answer, :weight])
    |> validate_required([:answer, :weight])
  end
end
