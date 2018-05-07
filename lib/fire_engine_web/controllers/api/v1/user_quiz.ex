defmodule FireEngineWeb.Api.V1.UserQuizController do
  use FireEngineWeb, :controller

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Quiz

  action_fallback FireEngineWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.params["user_id"]
    fe_quizzes = Assessments.list_quizzes_with_attempts(user_id)
    render(conn, "index.json", fe_quizzes: fe_quizzes)
  end


end
