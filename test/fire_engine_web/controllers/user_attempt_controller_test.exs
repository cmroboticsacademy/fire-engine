defmodule FireEngineWeb.UserAttemptControllerTest do
  import Plug.Test
  use FireEngineWeb.ConnCase
  use Timex

  alias FireEngine.Assessments
  alias FireEngine.Accounts
  alias FireEngine.Repo

  @admin_user %{id: 123,email: "some email", username: "some user", roles: [%{name: "admin"}]}
  @quiz %{attempts_allowed: 2, description: "some updated description", name: "some updated name", questions_per_page: 1, randomize_questions: false, time_closed: ~N[2011-06-18 15:01:01.000000], time_open: ~N[2011-05-18 15:01:01.000000]}
  @quiz_with_window %{attempts_allowed: 2, description: "some updated description", name: "some updated name", questions_per_page: 5, randomize_questions: false, time_closed: ~N[2011-06-18 15:01:01.000000], time_open: ~N[2011-05-18 15:01:01.000000], time_window: true}
  @quiz_time_limit %{attempts_allowed: 2, description: "some updated description", name: "some updated name", questions_per_page: 5, randomize_questions: false, time_closed: ~N[2011-06-18 15:01:01.000000], time_open: ~N[2011-05-18 15:01:01.000000], time_limit: true, time_limit_minutes: 20}
  @quiz_time_limit_no_auto_submit %{attempts_allowed: 2, description: "some updated description", name: "some updated name", questions_per_page: 5, randomize_questions: false, time_closed: ~N[2011-06-18 15:01:01.000000], time_open: ~N[2011-05-18 15:01:01.000000], time_limit: true, time_limit_minutes: 20, auto_submit: false}
  @autosubmit_disabled %{auto_submit: false,attempts_allowed: 2, description: "some updated description", name: "some updated name", questions_per_page: 5, randomize_questions: false, time_closed: ~N[2011-05-18 15:01:01.000000], time_open: ~N[2011-05-18 15:01:01.000000], time_window: true}
  @questions [%{content: "question 1", type: "multi", points: 1.0, answers: [%{answer: "answer1", weight: "1.0"}, %{answer: "answer2", weight: "0.0"}]},
  %{content: "question 2", type: "multi", points: 1.0, answers: [%{answer: "answer1", weight: "1.0"}, %{answer: "answer2", weight: "0.0"}]}]



  def fixture(:quiz) do
    {:ok, quiz} = Assessments.create_quiz(@quiz)
    quiz
  end

  def fixture(:quiz_time_limit_no_auto_submit) do
    {:ok, quiz} = Assessments.create_quiz(@quiz_time_limit_no_auto_submit)
    quiz
  end

  def fixture(:quiz_time_limit) do
    {:ok, quiz} = Assessments.create_quiz(@quiz_time_limit)
    quiz
  end

  def fixture(:questions) do
    questions = for q <- @questions do
      {:ok, question} = Assessments.create_question(q)
      question
    end
    questions
  end

  def fixture(:quiz_with_window) do
    {:ok, quiz} = Assessments.create_quiz(@quiz_with_window)
    quiz
  end

  def fixture(:autosubmit_disabled) do
    {:ok, quiz} = Assessments.create_quiz(@autosubmit_disabled)
    quiz
  end

  def fixture(:admin_user) do
    {:ok, admin_user} = FireEngine.Accounts.create_user(@admin_user)
    admin_user
  end

  def authenticate!(conn,user) do
    conn = conn
    |> init_test_session(user_id: user.id)
    |> assign(:user,user.id)
  end


  describe "check_quiz_window plug" do
    test "submits open attempt answers if autosubmit is enabled and quiz is past due", %{conn: conn} do
      quiz = fixture(:quiz_with_window)
      user = fixture(:admin_user)
      #create existing attempt
      {:ok, existing_attempt} = Assessments.create_attempt %{quiz_id: quiz.id, user_id: user.id}

      conn = authenticate!(conn, user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))
      "/u/quizzes" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)

      existing_attempt = Assessments.get_attempt!(existing_attempt.id)

      assert existing_attempt.closed == true
      assert html_response(conn, 200) =~ "This quiz is only open between #{quiz.time_open} and #{quiz.time_closed}"
    end

    test "ignores window dates if time_window is false", %{conn: conn} do
      quiz = fixture(:quiz)
      user = fixture(:admin_user)

      conn = authenticate!(conn, user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))

      assert html_response(conn, 302)
      assert Assessments.list_fe_attempts |> Enum.count == 1
    end

    test "discards open attempt answers if autosubmit is disabled", %{conn: conn} do

      #setup
      user = fixture(:admin_user)
      questions = fixture(:questions)
      quiz = fixture(:autosubmit_disabled)
      for q <- questions do
        Assessments.create_quiz_question(%{quiz_id: quiz.id, question_id: q.id})
      end
      quiz = Assessments.get_quiz!(quiz.id)

      #create existing attempt
      {:ok, existing_attempt} = Assessments.create_attempt %{quiz_id: quiz.id, user_id: user.id}

      #take quiz
      for r <- existing_attempt.responses do
        question = Assessments.get_question! r.question_id
        Assessments.update_response(r, %{answer_id: hd(question.answers).id})
      end

      existing_attempt = Assessments.get_attempt_with_responses(existing_attempt.id)

      conn = authenticate!(conn, user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))
      "/u/quizzes" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)

      existing_attempt = Assessments.get_attempt_with_responses(existing_attempt.id)


      assert existing_attempt.closed == true
      assert existing_attempt.responses |> Enum.all?(&(&1.answer_id == nil))
      assert html_response(conn, 200) =~ "This quiz is only open between #{quiz.time_open} and #{quiz.time_closed}"
    end

    test "redirects to user quiz path with message detailing open dates", %{conn: conn} do
      quiz = fixture(:autosubmit_disabled)
      user = fixture(:admin_user)

      conn = authenticate!(conn, user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))
      "/u/quizzes" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)

      assert html_response(conn, 200) =~ "This quiz is only open between #{quiz.time_open} and #{quiz.time_closed}"
    end

  end


  describe "CheckQuizTime Plug" do
    test "Redirects back to user quiz path with a time out message when time has expired", %{conn: conn} do
      quiz = fixture(:quiz_time_limit)
      user = fixture(:admin_user)
      {:ok, existing_attempt} = Assessments.create_attempt %{quiz_id: quiz.id, user_id: user.id}

      d = Duration.from_minutes(25)
      {:ok, existing_attempt} = Assessments.update_attempt(existing_attempt, %{start_time: Timex.subtract(existing_attempt.start_time,d)})

      conn = authenticate!(conn, user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))
      "/u/quizzes" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)

      assert html_response(conn, 200) =~ "This quiz has a #{quiz.time_limit_minutes} minutes limit. Your current attempt has expired"
    end

    test "Submits answers when autosubmit is enabled and time has expired", %{conn: conn} do
      #setup
      user = fixture(:admin_user)
      questions = fixture(:questions)
      quiz = fixture(:quiz_time_limit)
      for q <- questions do
        Assessments.create_quiz_question(%{quiz_id: quiz.id, question_id: q.id})
      end
      quiz = Assessments.get_quiz!(quiz.id)

      #create existing attempt
      {:ok, existing_attempt} = Assessments.create_attempt %{quiz_id: quiz.id, user_id: user.id}

      #take quiz
      for r <- existing_attempt.responses do
        question = Assessments.get_question! r.question_id
        Assessments.update_response(r, %{answer_id: hd(question.answers).id})
      end

      d = Duration.from_minutes(25)
      Assessments.update_attempt(existing_attempt, %{start_time: Timex.subtract(existing_attempt.start_time,d)})
      existing_attempt = Assessments.get_attempt_with_responses(existing_attempt.id)

      conn = authenticate!(conn, user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))
      "/u/quizzes" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)

      assert html_response(conn, 200) =~ "This quiz has a #{quiz.time_limit_minutes} minutes limit. Your current attempt has expired"
      assert existing_attempt.responses |> Enum.any?(&(&1.answer_id == nil)) == false
    end


    test "Deletes answers when autosubmit is disabled and time has expired", %{conn: conn} do
      #setup
      user = fixture(:admin_user)
      questions = fixture(:questions)
      quiz = fixture(:quiz_time_limit_no_auto_submit)
      for q <- questions do
        Assessments.create_quiz_question(%{quiz_id: quiz.id, question_id: q.id})
      end
      quiz = Assessments.get_quiz!(quiz.id)

      #create existing attempt
      {:ok, existing_attempt} = Assessments.create_attempt %{quiz_id: quiz.id, user_id: user.id}

      #take quiz
      for r <- existing_attempt.responses do
        question = Assessments.get_question! r.question_id
        Assessments.update_response(r, %{answer_id: hd(question.answers).id})
      end

      d = Duration.from_minutes(25)
      Assessments.update_attempt(existing_attempt, %{start_time: Timex.subtract(existing_attempt.start_time,d)})


      conn = authenticate!(conn, user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))
      "/u/quizzes" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)


      existing_attempt = Assessments.get_attempt_with_responses(existing_attempt.id)

      assert html_response(conn, 200) =~ "This quiz has a #{quiz.time_limit_minutes} minutes limit. Your current attempt has expired"
      assert existing_attempt.responses |> Enum.any?(&(&1.answer_id == nil)) == true
    end


  end



  describe "create" do

    test "opens a user attempt if another attempt is not open", %{conn: conn} do

      user = fixture(:admin_user)
      quiz = fixture(:quiz)

      conn = authenticate!(conn,user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))

      assert Assessments.list_fe_attempts |> Enum.count == 1
      assert html_response(conn, 302)
    end

    test "redirects to previous open attempt when an attempt is open", %{conn: conn} do
      user = fixture(:admin_user)
      quiz = fixture(:quiz)
      #create existing attempt
      {:ok,existing_attempt} = Assessments.create_attempt %{quiz_id: quiz.id, user_id: user.id}

      conn = authenticate!(conn, user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))

      response = Enum.into(conn.resp_headers, %{})
      location = response["location"]

      assert location =~ Integer.to_string(existing_attempt.id)
      assert Assessments.list_fe_attempts |> Enum.count == 1
      assert html_response(conn, 302)
    end

    test "does not open a user attempt when the attempt count exceeds the the attempt limit", %{conn: conn} do
      user = fixture(:admin_user)
      quiz = fixture(:quiz)
      #Create 2 attempts
      for _ <- 1..2, do: Assessments.create_attempt %{quiz_id: quiz.id, user_id: user.id}

      conn = authenticate!(conn, user)
      |> post(user_attempt_path(conn, :create, quiz_id: quiz.id, user_id: user.id))

      assert Assessments.list_fe_attempts |> Enum.count == 2
      "/u/quizzes" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)
      assert html_response(conn, 200) =~ "Exceeded number of attempts allowed for quiz"


    end
  end


  describe "edit" do

    test "Paginates quiz questions based on 'question per page' setting.", %{conn: conn} do
      #setup
      user = fixture(:admin_user)
      questions = fixture(:questions)
      quiz = fixture(:quiz)
      for q <- questions do
        Assessments.create_quiz_question(%{quiz_id: quiz.id, question_id: q.id})
      end
      quiz = Assessments.get_quiz!(quiz.id)
      #create attempt
      {:ok,attempt} = Assessments.create_attempt %{quiz_id: quiz.id, user_id: user.id}

      conn = authenticate!(conn, user)
      |> get(user_attempt_path(conn, :edit, attempt.id, quiz_id: quiz.id, page: 1))

      refute html_response(conn, 200) =~ List.last(questions).content
      assert html_response(conn, 200) =~ List.first(questions).content

      conn = get(conn,user_attempt_path(conn, :edit, attempt.id, quiz_id: quiz.id, page: 2))

      refute html_response(conn, 200) =~ List.first(questions).content
      assert html_response(conn, 200) =~ List.last(questions).content

    end

    test "Requesting a page that is not available redirects to the quiz submission page", %{conn: conn} do
      #setup
      user = fixture(:admin_user)
      questions = fixture(:questions)
      quiz = fixture(:quiz)
      for q <- questions do
        Assessments.create_quiz_question(%{quiz_id: quiz.id, question_id: q.id})
      end
      quiz = Assessments.get_quiz!(quiz.id)
      #create attempt
      {:ok,attempt} = Assessments.create_attempt %{quiz_id: quiz.id, user_id: user.id}

      conn = authenticate!(conn,user)
             |> get(user_attempt_path(conn, :edit, attempt.id, quiz_id: quiz.id, page: 3))
      match_route = "/u/attempts/#{attempt.id}"
      match_route = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)
      assert html_response(conn, 200) =~ "Save Quiz"
    end

  end


  defp create_quiz(_) do
    quiz = fixture(:quiz)
    {:ok, quiz: quiz}
  end
end
