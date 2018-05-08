defmodule FireEngineWeb.Api.V1.ResponseView do
  use FireEngineWeb, :view

  alias FireEngine.Assessments

  def render("response.json", %{response: response}) do
    %{answer_id: response.answer_id,
      answer: Assessments.get_answer!(response.answer_id).answer,
      question_id: response.question_id,
      question: Assessments.get_question!(response.question_id).content
    }
  end

end
