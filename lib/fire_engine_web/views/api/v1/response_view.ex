defmodule FireEngineWeb.Api.V1.ResponseView do
  use FireEngineWeb, :view

  alias FireEngine.Assessments

  def render("response.json", %{response: response}) do
    %{answer_id: response.answer_id,
      answer: get_answer(response.answer_id,:answer),
      correct: get_answer(response.answer_id,:weight),
      question_id: response.question_id,
      question: Assessments.get_question!(response.question_id).content,
      page: response.page
    }
  end

  def render("response-answer.json", %{response: response}) do
    %{answer_id: response.answer_id,
      answer: get_answer(response.answer_id,:answer),
      correct: get_answer(response.answer_id,:weight),
      correct_answer: Assessments.get_correct_answer(response.question_id),
      question_id: response.question_id,
      question: Assessments.get_question!(response.question_id).content,
      page: response.page
    }
  end

  defp get_answer(id,field) when is_nil(id), do: nil
  defp get_answer(id,field) when is_integer(id) do
    {:ok, attribute} = Assessments.get_answer!(id) |> Map.fetch(field)
    attribute
  end
end
