# Create this test in test/controllers/todo_controller_test.exs
defmodule FireEngine.UserAttemptControllerTest do
  import Plug.Test
  import FireEngine.Factory

  alias FireEngine.Assessments

  use FireEngineWeb.ConnCase

  test "#create generates an attempt with responses for each quiz question" do
    conn = build_conn()
    question = insert(:question)
    answer = question.answers |> List.first
    quiz_question = %{quiz_questions: [%{question_id: question.id}]}
    quiz = insert(:quiz,quiz_question)
    user = insert(:user)

    conn = post conn, "api/v1/user_attempts?user_id=#{user.id}&quiz_id=#{quiz.id}"
    attempt = Assessments.list_fe_attempts |> List.first
    assert Assessments.list_fe_attempts() |> Enum.count == 1
    assert  Assessments.list_fe_responses() |> Enum.count == 1

    assert json_response(conn, 200) == %{"data" =>
      %{"attempt_id" => attempt.id,
        "quiz_name" => quiz.name,
        "page_number" => 1,
        "total_pages" => 1,
        "questions" => [
          %{
            "id" => question.id,
            "content" => question.content,
            "answers"=> [%{
              "id" => answer.id,
               "answer" => answer.answer
              }]
          }
        ]
      }
    }
  end
end
