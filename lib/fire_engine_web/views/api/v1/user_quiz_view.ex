defmodule FireEngineWeb.Api.V1.UserQuizView do
  use FireEngineWeb, :view
  alias FireEngine.Assessments

  def render("index.json", %{fe_quizzes:  quizzes}) do
    %{data: render_many(quizzes, FireEngineWeb.Api.V1.UserQuizView, "quiz.json")}
  end

  def render("quiz.json", %{user_quiz: user_quiz}) do
    user_quiz
  end

  def render("show.json", %{attempts: attempts}) do
    quiz = List.first(attempts)
    %{data:
      if quiz do
        %{
          id: quiz.quiz_id,
          name: quiz.name,
          description: quiz.description,
          questions: quiz.number_of_questions,
          estimated_duration_minutes: Assessments.get_quiz_duration(quiz.quiz_id),
          attempts: render_many(attempts, FireEngineWeb.Api.V1.UserAttemptView, "attempt-simple.json")
        }
      else
        []
      end
    }
  end

end
