defmodule FireEngine.Assessments.Quiz do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Assessments.Quiz


  schema "fe_quizzes" do
    field :attempts_allowed, :integer
    field :description, :string
    field :name, :string
    field :questions_per_page, :integer
    field :randomize_questions, :boolean, default: false
    field :time_closed, :naive_datetime
    field :time_open, :naive_datetime
    field :color_index, :string
    field :show_answers, :boolean, default: true
    field :auto_submit, :boolean, default: true
    field :time_window, :boolean, default: false
    field :time_limit, :boolean, default: false
    field :time_limit_minutes, :integer

    has_many :quiz_questions, FireEngine.Assessments.QuizQuestion
    many_to_many :questions, FireEngine.Assessments.Question, join_through: "fe_quiz_questions", on_delete: :delete_all, on_replace: :delete
    has_many :attempts, FireEngine.Assessments.Attempt, on_delete: :delete_all

    timestamps(usec: false)
  end

  @doc false
  def changeset(%Quiz{} = quiz, attrs) do
    quiz
    |> cast(attrs, [:name, :description, :attempts_allowed, :randomize_questions, :questions_per_page, :time_open, :time_closed, :color_index, :auto_submit, :time_window, :time_limit, :time_limit_minutes, :show_answers])
    |> validate_required([:name, :description, :attempts_allowed, :randomize_questions, :questions_per_page])
    |> cast_assoc(:questions)
  end
end
