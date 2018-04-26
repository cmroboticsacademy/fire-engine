defmodule FireEngineWeb.Plug.Helpers do
  import Plug.Conn
  import Phoenix.Controller

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Attempt

  def close_attempt(user_id, quiz_id) do
    case Assessments.has_open_attempt?(user_id, quiz_id) do
      {:ok, attempt_id} ->
        attempt = Assessments.get_attempt_with_responses(attempt_id)
        |> apply_auto_submit_rules
        |> Assessments.update_attempt(%{closed: true})
      nil ->
        nil
    end
  end


  defp apply_auto_submit_rules(attempt = %Attempt{}) do
    auto_submit = Assessments.get_quiz!(attempt.quiz_id).auto_submit
    case auto_submit do
      true ->
        attempt
      false ->
        # Answers are rejected when auto_submit is disabled
        for r <- attempt.responses do
          Assessments.update_response(r, %{answer_id: nil} )
        end
        attempt
    end
  end


end
