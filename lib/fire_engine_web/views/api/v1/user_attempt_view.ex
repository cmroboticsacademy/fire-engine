defmodule FireEngineWeb.Api.V1.UserAttemptView do
  use FireEngineWeb, :view

  def render("attempt.json", %{attempt: attempt, quiz: quiz, questions: questions, page: page}) do
    %{data:
      %{attempt_id: attempt.id,
        page_number: questions.page_number,
        total_pages: questions.total_pages,
        quiz_name: quiz.name,
        questions: question_format(questions.entries)
      }
    }
  end

  defp question_format(questions) do
    answers = questions
    |> Enum.flat_map(&(&1.answers))
    |> Enum.map(&(%{id: &1.id, answer: &1.answer}))

    questions = questions
    |> Enum.map(&(%{content: &1.content, id: &1.id, answers: answers}))
  end

end
