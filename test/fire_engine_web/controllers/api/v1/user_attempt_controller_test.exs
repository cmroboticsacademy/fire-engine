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

    json_data = Poison.encode! %{user_id: user.id,quiz_id: quiz.id}

    conn = post conn, "api/v1/user_attempts", [data: json_data]
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
            "question_id" => question.id,
            "question" => question.content,
            "answers"=> [%{
              "answer_id" => answer.id,
               "answer" => answer.answer
              }]
          }
        ]
      }
    }
  end

  test "#update persists user response data and returns quiz submit page when no pages remain" do
    conn = build_conn()
    question = insert(:question)
    answer = question.answers |> List.first
    quiz_question = %{quiz_questions: [%{question_id: question.id}]}
    quiz = insert(:quiz, quiz_question)
    user = insert(:user)

    {:ok, attempt} = Assessments.create_attempt(%{user_id: user.id, quiz_id: quiz.id})
    response = attempt.responses |> List.first

    json_data = Poison.encode! %{responses: [%{answer_id: answer.id, question_id: question.id}], page: 1, user_id: user.id, quiz_id: quiz.id }

    conn = put conn, "api/v1/user_attempts/#{attempt.id}", [data: json_data]

    assert json_response(conn, 200) == %{"data" => %{
        "attempt_id" => attempt.id,
        "quiz_id" => quiz.id,
        "quiz" => quiz.name,
        "page_number" => "review_attempt",
        "responses" => [%{
          "question_id" => question.id,
          "question" => question.content,
          "answer_id" => answer.id,
          "answer" => answer.answer
        }]
      }}


   updated_attempt = Assessments.get_attempt_with_responses(attempt.id)
   assert updated_attempt.responses |> Enum.filter(&(&1.answer_id == answer.id)) |> Enum.any?


  end


  test "#update persists user response data and returns next quiz page" do
    conn = build_conn()
    questions = insert_list(3,:question)
    quiz_questions = for q <- questions do
      %{question_id: q.id}
    end
    quiz_params = %{questions_per_page: 1,quiz_questions: quiz_questions}
    quiz = insert(:quiz, quiz_params)
    user = insert(:user)

    {:ok, attempt} = Assessments.create_attempt(%{user_id: user.id, quiz_id: quiz.id})


    question = List.first(questions)
    answer = question.answers |> List.first
    json_data = Poison.encode! %{responses: [%{answer_id: answer.id, question_id: question.id}], page: 1, user_id: user.id, quiz_id: quiz.id}

    conn = put conn, "api/v1/user_attempts/#{attempt.id}", [data: json_data]

    {next_question, _} = List.pop_at(questions, 1)
    next_answer = List.first(next_question.answers)

    assert json_response(conn, 200) == %{"data" =>
      %{"attempt_id" => attempt.id,
        "quiz_name" => quiz.name,
        "page_number" => 2,
        "total_pages" => 3,
        "questions" => [
          %{
            "question_id" => next_question.id,
            "question" => next_question.content,
            "answers"=> [%{
              "answer_id" => next_answer.id,
               "answer" => next_answer.answer
              }]
          }
        ]
      }
    }

  end


  test "#show displays requested attempt and questions for the page requested" do
    conn = build_conn()
    questions = insert_list(3,:question)
    quiz_questions = for q <- questions do
      %{question_id: q.id}
    end
    quiz_params = %{questions_per_page: 1,quiz_questions: quiz_questions}
    quiz = insert(:quiz, quiz_params)
    user = insert(:user)

    {:ok, attempt} = Assessments.create_attempt(%{user_id: user.id, quiz_id: quiz.id})

    question = List.first(questions)
    answer = question.answers |> List.first

    conn = get conn, "api/v1/user_attempts/#{attempt.id}?page=1"

    assert json_response(conn, 200) == %{"data" =>
      %{"attempt_id" => attempt.id,
        "quiz_name" => quiz.name,
        "page_number" => 1,
        "total_pages" => 3,
        "questions" => [
          %{
            "question_id" => question.id,
            "question" => question.content,
            "answers"=> [%{
              "answer_id" => answer.id,
               "answer" => answer.answer
              }]
          }
        ]
      }
    }



  end

  test "#save closes attempt and generates a score" do
    conn = build_conn()
    question = insert(:question)
    quiz_params = %{quiz_questions: [%{question_id: question.id}]}
    quiz = insert(:quiz, quiz_params)
    user = insert(:user)

    {:ok, attempt} = Assessments.create_attempt(%{user_id: user.id, quiz_id: quiz.id})
    answer = question.answers |> List.first

    conn = post conn, "api/v1/user_attempts/save/#{attempt.id}"

    assert json_response(conn, 200) == %{"data" => %{
      "attempt_id" => attempt.id,
      "quiz_id" => quiz.id,
      "point_percent" =>  0.0,
      "point_total" => 0.0,
      "points_available" => 1.0,
      "closed" => true,
      "date_completed" => NaiveDateTime.to_string(attempt.updated_at)
      }}

  end


end
