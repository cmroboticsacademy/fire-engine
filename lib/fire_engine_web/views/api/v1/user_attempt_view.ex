defmodule FireEngineWeb.Api.V1.UserAttemptView do
  use FireEngineWeb, :view

  def render("attempt.json", %{attempt: attempt, quiz: quiz, questions: questions, page: page}) do
    %{data:
      %{attempt_id: attempt.id,
        page_number: questions.page_number,
        total_pages: questions.total_pages,
        quiz_name: quiz.name,
        questions: render_many(questions.entries, FireEngineWeb.Api.V1.QuestionView, "question.json")
      }
    }
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


end
