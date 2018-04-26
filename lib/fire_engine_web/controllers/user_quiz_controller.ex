defmodule FireEngineWeb.UserQuizController do
  use FireEngineWeb, :controller

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Quiz

  #plug FireEngine.Plugs.RequireAuth
  plug FireEngine.Plugs.RequireCasAuth
  plug FireEngine.Plugs.CheckRequestType

  action_fallback FireEngineWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.assigns[:user].id
    fe_quizzes = Assessments.list_quizzes_with_attempts(user_id)
    render(conn, "index.html", fe_quizzes: fe_quizzes)
  end


  def show(conn, %{"id" => id}) do
    quiz = Assessments.get_quiz_with_questions(id)
    render(conn, "show.html", quiz: quiz)
  end


end
