defmodule FireEngineWeb.Api.V1.QuestionView do
  use FireEngineWeb, :view
  def render("question.json", %{question: question, responses: responses}) do
    %{question_id: question.id,
      question: question.content,
      answers: render_many(question.answers, FireEngineWeb.Api.V1.AnswerView, "answer.json", responses: responses)
    }
  end
end
