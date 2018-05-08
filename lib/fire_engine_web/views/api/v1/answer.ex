defmodule FireEngineWeb.Api.V1.AnswerView do
  use FireEngineWeb, :view
  def render("answer.json", %{answer: answer}) do
    %{
      answer_id: answer.id,
      answer: answer.answer
    }

  end
end
