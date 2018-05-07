# Create this test in test/controllers/todo_controller_test.exs
defmodule FireEngine.UserQuizControllerTest do
  import Plug.Test
  import FireEngine.Factory

  use FireEngineWeb.ConnCase

  test "#index renders a list of user quizzes" do
    conn = build_conn()
    quiz = insert(:quiz)
    user = insert(:user)

    conn = get conn, "api/v1/quizzes?user_id=#{user.id}"
    assert json_response(conn, 200) == %{
      "data" => [%{
        "id" => quiz.id,
        "name" => quiz.name,
        "description" => quiz.description,
        "attempt_count" => 0,
        "attempts_allowed" => quiz.attempts_allowed,
        "avg_score" => nil,
        "best_score" => nil,
        "lowest_score" => nil,
        "questions_per_page" => quiz.questions_per_page
        }]
    }
  end
end
