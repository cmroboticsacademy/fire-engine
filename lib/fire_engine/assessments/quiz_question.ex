defmodule FireEngine.Assessments.QuizQuestion do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Assessments.QuizQuestion


  schema "fe_quiz_questions" do
    field :question_id, :integer
    field :quiz_id, :integer

    has_many :questions, FireEngine.Assessments.Question, on_delete: :delete_all
    has_many :quizzes, FireEngine.Assessments.Quiz, on_delete: :delete_all

    timestamps(usec: false)
  end

  @doc false
  def changeset(%QuizQuestion{} = quiz_question, attrs) do
    quiz_question
    |> cast(attrs, [:quiz_id, :question_id])
    |> validate_required([:quiz_id, :question_id])
  end
end
