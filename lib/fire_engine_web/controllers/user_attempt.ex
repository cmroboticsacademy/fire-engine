defmodule FireEngineWeb.UserAttemptController do
  use FireEngineWeb, :controller

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Attempt
  alias FireEngine.Assessments.Response

  plug FireEngine.Plugs.RequireCasAuth
  plug FireEngine.Plugs.CheckRequestType
  plug FireEngine.Plugs.CheckQuizWindow  when action in [:create, :edit]
  plug FireEngine.Plugs.CheckQuizTime when action in [:create, :edit]

  action_fallback FireEngineWeb.FallbackController

  def create(conn, %{"quiz_id" => quiz_id, "user_id" => user_id} = params) do
    quiz = Assessments.get_quiz!(quiz_id)
    attempt_count = Assessments.quiz_total_user_attempts(quiz_id, user_id)

    if attempt_count < quiz.attempts_allowed do
      attrs = %{quiz_id: quiz_id, user_id: user_id, open: quiz.time_open, closes: quiz.time_closed}
      open_attempt = Assessments.has_open_attempt?(user_id,quiz_id)

      case open_attempt do
        {:ok, attempt_id} ->
          conn |> redirect(to: user_attempt_path(conn, :edit, attempt_id, quiz_id: quiz, page: 1))
        nil ->
          with {:ok, %Attempt{} = attempt} <- Assessments.create_attempt(attrs) do
            conn
            |> redirect(to: user_attempt_path(conn, :edit, attempt, quiz_id: quiz, page: 1))
          end
      end
    else
      conn
      |> put_flash(:info, "Exceeded number of attempts allowed for quiz")
      |> redirect(to: user_quiz_path(conn, :index))
    end

  end

  def edit(conn,%{"id" => attempt_id, "quiz_id" => quiz_id, "page" => page} = params) do


    page = String.to_integer(page)
    {quiz,questions} = Assessments.get_quiz_with_questions(quiz_id, page)
    attempt = Assessments.get_attempt_with_responses(attempt_id)
    changeset = Assessments.change_attempt(attempt)

    case last_page?(questions) do
      false ->
        render(conn, "edit.html", quiz: quiz, changeset: changeset, attempt: attempt, questions: questions)
      true ->
        conn
        |> redirect(to: user_attempt_path(conn, :show, attempt))
    end

  end

  def update(conn,%{"attempt" => attempt, "page" => page, "quiz_id" => quiz_id} = params) do
     {:ok, new_attempt} = Assessments.get_attempt!(attempt["id"])
     |> Assessments.update_attempt(attempt)

     next_page = String.to_integer(page) + 1

     conn
     |> redirect(to: user_attempt_path(conn,:edit, new_attempt, quiz_id: quiz_id, page: next_page))
  end

  def save(conn, %{"id" => attempt_id}) do
    attempt = Assessments.get_attempt!(attempt_id)

    case Assessments.update_attempt(attempt, %{closed: true}) do
      {:ok, attempt} ->
        conn
        |> calculate_grade(attempt)
        |> put_flash(:info, "Quiz Submitted")
        |> redirect(to: user_quiz_path(conn, :index))
    end

  end

  def show(conn,%{"id" => id} = params) do
    responses = Assessments.get_attempt_in_quiz_form(id)
    render(conn, "show.html",responses: responses, attempt: id)
  end


  defp calculate_grade(conn, %{id: attempt_id, quiz_id: quiz_id} = attempt) do
    total_points = Assessments.quiz_total_points(quiz_id)
    earned_points = Assessments.attempt_earned_points(attempt_id)
    score = (earned_points / total_points) * 100.0

    Assessments.update_attempt(attempt, %{point_percent: score, point_total: earned_points, points_available: total_points})
    conn
  end

  defp last_page?(%Scrivener.Page{page_number: page_number, total_pages: total_pages}) do
    cond do
      page_number > total_pages ->
        true
      true ->
        false
    end
  end



end
