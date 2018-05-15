defmodule FireEngineWeb.Api.V1.AnswerView do
  use FireEngineWeb, :view
  def render("answer.json", %{answer: answer, responses: responses}) do
    %{
      answer_id: answer.id,
      answer: answer.answer,
      selected: is_selected?(answer,responses)
    }
  end

  defp is_selected?(answer,responses) do
    responses |> Enum.any?(&(&1.answer_id == answer.id))
  end

end
