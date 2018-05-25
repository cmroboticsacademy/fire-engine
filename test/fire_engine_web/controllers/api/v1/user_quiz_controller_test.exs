# Create this test in test/controllers/todo_controller_test.exs
defmodule FireEngine.UserQuizControllerTest do
  import Plug.Test
  import FireEngine.Factory
  alias FireEngine.Assessments

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

  test "#show returns a user quiz with a summary of attempts" do
    conn = build_conn()

    question = insert(:question)
    quiz_question = %{quiz_questions: [%{question_id: question.id}]}
    quiz = insert(:quiz,quiz_question)
    user = insert(:user)

    {:ok, attempt} = Assessments.create_attempt(%{quiz_id: quiz.id, user_id: user.id})

    conn = get conn, "api/v1/quizzes/#{quiz.id}?user_id=#{user.id}"

    assert json_response(conn, 200) == %{
      "data" => %{
        "id" => quiz.id,
        "name" => quiz.name,
        "description" => quiz.description,
        "questions" => 1,
        "estimated_duration_minutes" => 1,
        "attempts" => [%{
            "start_time" => NaiveDateTime.to_string(attempt.start_time),
            "point_total" => attempt.point_total,
            "point_percent" => attempt.point_percent,
            "points_available" => attempt.points_available,
            "closes" => attempt.closes,
            "closed" => attempt.closed
          }]
        }
    }

  end
end
