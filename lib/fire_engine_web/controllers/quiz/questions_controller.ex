defmodule FireEngineWeb.Quiz.QuestionsController do
  use FireEngineWeb, :controller

  alias FireEngine.Assessments

  plug FireEngine.Plugs.RequireCasAuth
  plug FireEngine.Plugs.VerifyAdmin

  action_fallback FireEngineWeb.FallbackController

  def index(conn,%{"quiz_id" => quiz_id} = params) do
    quiz = Assessments.get_quiz_with_questions(quiz_id)

    current_questions = quiz.questions |> Enum.map(&(&1.content))
    if Map.has_key?(params,"tag") && params["tag"] != "" do
      questions = Assessments.list_fe_questions(current_questions, "%#{params["tag"]}%")
    else
      questions = Assessments.list_fe_questions(current_questions)
    end
    render(conn,:index,quiz: quiz, questions: questions)
  end

  def import(conn,%{"import" => imported, "quiz_id" => quiz_id} = params) do
    questions = Map.values(imported) |> Enum.reject(&(&1 == "false"))

    for question <- questions do
      case Assessments.create_quiz_question(%{quiz_id: quiz_id, question_id: question}) do
        {:ok, _params} ->
          conn
          |> put_flash(:info, "Successfully Imported Questions")
          |> redirect(to: quiz_path(conn,:edit, quiz_id))
      end
    end

  end



end
