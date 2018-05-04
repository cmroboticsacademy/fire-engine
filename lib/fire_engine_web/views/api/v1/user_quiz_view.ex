defmodule FireEngineWeb.Api.V1.UserQuizView do
  use FireEngineWeb, :view

  def render("index.json", %{fe_quizzes:  quizzes}) do
    %{data: render_many(quizzes, FireEngineWeb.Api.V1.UserQuizView, "quiz.json")}
  end

  def render("quiz.json", %{user_quiz: user_quiz}) do
    user_quiz
  end

end
