defmodule FireEngineWeb.Api.V1.UserAttemptController do
  use FireEngineWeb, :controller

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Attempt
  alias FireEngine.Assessments.Response

  plug FireEngine.Plugs.SetUserApi when action in [:create, :edit]
  plug FireEngine.Plugs.CheckQuizWindow  when action in [:create, :edit]
  plug FireEngine.Plugs.CheckQuizTime when action in [:create, :edit]

  def create(conn, %{"data" => data} = params) do

    quiz_id = decode_data(data, "quiz_id")
    user_id = decode_data(data, "user_id")
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
      |> render(FireEngineWeb.Api.V1.UserQuizView, "index.json")
    end
  end

  def update(conn, %{"data" => data, "id" => attempt_id} = params) do
    submitted_responses = decode_data(data, "responses")
    page = decode_data(data, "page")
    attempt = Assessments.get_attempt_with_responses(attempt_id)

    next_page = turn_page(page)

    {quiz,questions} = Assessments.get_quiz_with_questions(attempt.quiz_id, next_page)

    case update_response(attempt, submitted_responses) do
      {:ok, updated_attempt} ->
        if last_page?(questions) do
          conn
          |> render("review_attempt.json", attempt: updated_attempt, quiz: quiz)
        else
          conn
          |> render("attempt.json", attempt: updated_attempt,questions: questions ,page: questions.page_number, quiz: quiz)
        end
      {:error, _} ->
        conn
        |> render("attempt_submit_error.json", attempt: attempt)
    end

  end

  def show(conn, %{"id" => id, "page" => page} = params) do
    page = String.to_integer(page)
    attempt_id = String.to_integer(id)
    attempt = Assessments.get_attempt_with_responses(attempt_id)

    quiz = Assessments.get_quiz!(attempt.quiz_id)
    {quiz,questions} = Assessments.get_quiz_with_questions(attempt.quiz_id, page)

    conn
    |> render("attempt.json", attempt: attempt, questions: questions, page: questions.page_number, quiz: quiz)

  end


  def save(conn, %{"id" => attempt_id}) do
    attempt = Assessments.get_attempt!(attempt_id)

    case Assessments.update_attempt(attempt, %{closed: true}) do
      {:ok, attempt} ->
        conn
        |> calculate_grade(attempt)
        |> render("attempt_submitted.json",attempt: Assessments.get_attempt!(attempt.id))
    end

  end


  defp update_response(attempt,responses) do
    #Update all attempt.responses with json responses, return :ok or :error
    try do
      for sr <- responses do
        response = attempt.responses |> Enum.filter(&(&1.question_id == sr["question_id"])) |> List.first
        Assessments.update_response(response, %{answer_id: sr["answer_id"]})
      end
      updated_attempt = Assessments.get_attempt_with_responses(attempt.id)
      {:ok, updated_attempt}
    rescue
      _ ->
        {:error, nil}
    end
  end

  defp last_page?(%Scrivener.Page{page_number: page_number, total_pages: total_pages}) do
    cond do
      page_number > total_pages ->
        true
      true ->
        false
    end
  end


  defp calculate_grade(conn, %{id: attempt_id, quiz_id: quiz_id} = attempt) do
    total_points = Assessments.quiz_total_points(quiz_id)
    earned_points = Assessments.attempt_earned_points(attempt_id)
    score = (earned_points / total_points) * 100.0

    Assessments.update_attempt(attempt, %{point_percent: score, point_total: earned_points, points_available: total_points})
    conn
  end






  defp turn_page(page) when is_nil(page), do: 1
  defp turn_page(page) when is_bitstring(page), do: String.to_integer(page) + 1
  defp turn_page(page) when is_integer(page), do: page + 1

  defp decode_data(data = %{},key), do: data[key]
  defp decode_data(data, key), do: Poison.decode!(data)[key]



end
