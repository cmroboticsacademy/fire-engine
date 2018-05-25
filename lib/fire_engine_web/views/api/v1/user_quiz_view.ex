defmodule FireEngineWeb.Api.V1.UserQuizView do
  use FireEngineWeb, :view
  alias FireEngine.Assessments

  def render("index.json", %{fe_quizzes:  quizzes}) do
    %{data: render_many(quizzes, FireEngineWeb.Api.V1.UserQuizView, "quiz.json")}
  end

  def render("quiz.json", %{user_quiz: user_quiz}) do
    user_quiz
  end

  def render("show.json", %{quiz: quiz}) do
    %{data:
        %{
          id: quiz.id,
          name: quiz.name,
          description: quiz.description,
          questions: quiz.questions |> Enum.count,
          estimated_duration_minutes: Assessments.get_quiz_duration(quiz.id),
          attempts: render_many(quiz.attempts, FireEngineWeb.Api.V1.UserAttemptView, "attempt-simple.json")
        }
    }
  end

end
