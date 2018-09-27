defmodule FireEngine.Plugs.CheckQuizTime do

  import Plug.Conn
  import Phoenix.Controller

  alias FireEngineWeb.Router.Helpers
  alias FireEngine.Assessments
  alias FireEngine.Accounts
  alias FireEngineWeb.Api.V1.UserAttemptView

  def init(_params) do
  end

  def call(conn,_params) do
    attempt = get_attempt(conn)
    quiz = Assessments.get_quiz!(attempt.quiz_id)

    if time_is_up?(quiz,attempt) do
      FireEngineWeb.Plug.Helpers.close_attempt(attempt.user_id,quiz.id)
      conn
      |> render(UserAttemptView, "attempt-expired.json")
      |> halt()
    else
      conn
    end

  end


  defp time_is_up?(%{time_limit: true} = quiz,attempt) do
    time_left = UserAttemptView.time_left(attempt.start_time,quiz.time_limit_minutes)
    cond do
      time_left > 0 ->
        false
      time_left <= 0 ->
        true
    end
  end

  defp time_is_up?(%{time_limit: false} = quiz, _ ), do: false


  defp get_attempt(%{params: params} = conn) do
    %{"id" => attempt_id} = params
    Assessments.get_attempt!(attempt_id)
  end


end
