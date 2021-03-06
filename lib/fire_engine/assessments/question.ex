defmodule FireEngine.Assessments.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Assessments.Question

  schema "fe_questions" do
    field :content, :string
    field :points, :float
    field :type, :string

    many_to_many :quizzes, FireEngine.Assessments.Quiz, join_through: "fe_quiz_questions"
    has_many :answers, FireEngine.Assessments.Answer, on_delete: :delete_all, on_replace: :delete
    has_many :responses, FireEngine.Assessments.Response, on_delete: :delete_all
    many_to_many :tags, FireEngine.Assessments.Tag, join_through: "fe_question_tags", on_delete: :delete_all, on_replace: :delete
    has_many :question_tags, FireEngine.Assessments.QuestionTag, on_delete: :delete_all, on_replace: :delete
    belongs_to :category, FireEngine.Assessments.Category


    timestamps(usec: false)
  end

  @doc false
  def changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:content, :type, :points, :category_id])
    |> validate_required([:content])
    |> cast_assoc(:answers)
    |> cast_assoc(:question_tags)
    |> check_weights()
  end

  defp check_weights(%{changes: %{answers: answers}} = changeset) do
    IO.inspect changeset

    question = changeset.data
    mapped_answers = answers |> Enum.map(fn a -> Map.merge(a.data,a.changes) end)

    if sum_weights(mapped_answers) > 1.0 do
      add_error(changeset,:answers, "Cannot have answer weights that exceed the total points for a question.")
    else
      changeset
    end
  end

  defp check_weights(changeset), do: changeset  

  defp sum_weights(answers) do
    answers
    |> Enum.map(fn a -> a.weight end)
    |> Enum.sum
  end

end
