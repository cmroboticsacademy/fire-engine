defmodule FireEngineWeb.Api.V1.UserAttemptView do
  use FireEngineWeb, :view

  alias FireEngine.Assessments

  def render("attempt.json", %{attempt: attempt, quiz: quiz, questions: questions, page: page}) do
    %{data:
      %{attempt_id: attempt.id,
        page_number: questions.page_number,
        total_pages: questions.total_pages,
        quiz_name: quiz.name,
        questions: render_many(questions.entries, FireEngineWeb.Api.V1.QuestionView, "question.json", responses: attempt.responses)
      }
    }
  end

  def render("attempts-exceeded.json", _params) do
     %{data: %{message: "attempts exceeded"}}
  end

  def render("attempt-simple.json", %{user_attempt: user_attempt}) do
    %{closed: user_attempt.closed, closes: user_attempt.closes, point_percent: user_attempt.point_percent, point_total: user_attempt.point_total, points_available: user_attempt.points_available, start_time: NaiveDateTime.to_string(user_attempt.start_time)}
  end

  def render("review_attempt.json", %{attempt: attempt, quiz: quiz}) do
    %{data:
      %{attempt_id: attempt.id,
        quiz_id: quiz.id,
        quiz: quiz.name,
        page_number: :review_attempt,
        responses: render_many(attempt.responses,FireEngineWeb.Api.V1.ResponseView,"response.json")
      }
    }
  end

  def render("attempt_submitted.json", %{attempt: attempt}) do
    %{data:
      %{attempt_id: attempt.id,
        quiz_id: attempt.quiz_id,
        point_percent: attempt.point_percent,
        point_total: attempt.point_total,
        points_available: attempt.points_available,
        closed: attempt.closed,
        date_completed: NaiveDateTime.to_string(attempt.updated_at),
        responses:
        render_many(attempt.responses, FireEngineWeb.Api.V1.ResponseView,response_template(attempt.quiz_id))
    }

  }

  end

  defp response_template(quiz_id) do
    case Assessments.get_quiz!(quiz_id) do
      %Assessments.Quiz{show_answers: true} ->
        "response-answer.json"
      _ ->
        "response.json"
    end
  end


end
