defmodule FireEngineWeb.Api.V1.UserAttemptController do
  use FireEngineWeb, :controller

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Attempt
  alias FireEngine.Assessments.Response

  def create(conn, %{"quiz_id" => quiz_id, "user_id" => user_id} = params) do
    quiz = Assessments.get_quiz!(quiz_id)
    attempt_count = Assessments.quiz_total_user_attempts(quiz_id, user_id)
    if attempt_count < quiz.attempts_allowed do
      attrs = %{quiz_id: quiz_id, user_id: user_id, open: quiz.time_open, closes: quiz.time_closed}
      open_attempt = Assessments.has_open_attempt?(user_id,quiz_id)

      case open_attempt do
        {:ok, attempt_id} ->
          attempt = Assessments.get_attempt!(attempt_id)
          {quiz,questions} = Assessments.get_quiz_with_questions(quiz_id, 1)
          conn
          |> render("attempt.json", attempt: attempt, quiz: quiz,questions: questions, page: 1)
        nil ->
          with {:ok, attempt } <- Assessments.create_attempt(attrs) do
            {quiz,questions} = Assessments.get_quiz_with_questions(quiz_id, 1)
            conn
            |> render("attempt.json", attempt: attempt, quiz: quiz, questions: questions, page: 1) 
          end
      end
    else
      conn
      |> put_flash(:info, "Exceeded number of attempts allowed for quiz")
      |> redirect(to: user_quiz_path(conn, :index))
    end
  end

end
