defmodule FireEngineWeb.QuizControllerTest do
  import Plug.Test
  use FireEngineWeb.ConnCase

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Quiz

  @create_attrs %{attempts_allowed: 42, description: "some description", name: "some name", questions_per_page: 1, randomize_questions: true, real_time_feedback: true, show_correct_answer: true, single_attempt_per_question: true, time_closed: ~N[2010-04-17 14:00:00.000000], time_open: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{attempts_allowed: 43, description: "some updated description", name: "some updated name", questions_per_page: 1, randomize_questions: false, real_time_feedback: false, show_correct_answer: false, single_attempt_per_question: false, time_closed: ~N[2011-05-18 15:01:01.000000], time_open: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{attempts_allowed: nil, description: nil, name: nil, questions_per_page: nil, randomize_questions: nil, real_time_feedback: nil, show_correct_answer: nil, single_attempt_per_question: nil, time_closed: nil, time_open: nil}
  @admin_user %{id: 123,email: "some email", username: "some user", roles: [%{name: "admin"}]}


  def fixture(:quiz) do
    {:ok, quiz} = Assessments.create_quiz(@create_attrs)
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
    conn
  end


  describe "index" do
    test "lists all fe_quizzes", %{conn: conn} do

      user = fixture(:admin_user)

      conn = authenticate!(conn,user)
      |> get(quiz_path(conn, :index))

      assert html_response(conn, 200) =~ "Quiz Bank"
    end
  end

  describe "create quiz" do
    test "renders quiz when data is valid", %{conn: conn} do

      user = fixture(:admin_user)

      conn = conn
      |> authenticate!(user)
      |> post(quiz_path(conn, :create), quiz: @create_attrs)

      assert html_response(conn, 302)

    end

    test "renders missing data fields when data is invalid", %{conn: conn} do
      user = fixture(:admin_user)

      conn = conn
      |> authenticate!(user)
      |> post(quiz_path(conn,:create), quiz: @invalid_attrs)
      assert html_response(conn, 200) =~ "Correct Your Submission"
    end
  end

  describe "update quiz" do
    setup [:create_quiz]

    test "renders quiz when data is valid", %{conn: conn, quiz: %Quiz{id: id} = quiz} do
      user = fixture(:admin_user)

      conn = conn
      |> authenticate!(user)
      |> put(quiz_path(conn, :update, quiz), quiz: @update_attrs)

      quiz = Assessments.get_quiz_with_questions(id)
      assert quiz.name =~ @update_attrs.name
      assert html_response(conn,302)

    end

    test "renders errors when data is invalid", %{conn: conn, quiz: quiz} do
      user = fixture(:admin_user)

      conn = conn
      |> authenticate!(user)
      |> put(quiz_path(conn, :update, quiz), quiz: @invalid_attrs)
      assert html_response(conn, 200) =~ "Correct Your Submission"
    end
  end

  describe "delete quiz" do
    setup [:create_quiz]

    test "deletes chosen quiz", %{conn: conn, quiz: quiz} do
      user = fixture(:admin_user)

      conn = conn
      |> authenticate!(user)
      |> delete(quiz_path(conn, :delete, quiz))

      assert response(conn, 302)

      conn = get conn, quiz_path(conn, :show, quiz)
      assert conn.status == 404
    end
  end

  defp create_quiz(_) do
    quiz = fixture(:quiz)
    {:ok, quiz: quiz}
  end
end
