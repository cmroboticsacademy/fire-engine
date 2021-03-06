defmodule FireEngineWeb.QuizController do
  use FireEngineWeb, :controller

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Quiz
  alias FireEngine.Repo

  plug FireEngine.Plugs.RequireCasAuth
  plug FireEngine.Plugs.VerifyAdmin

  action_fallback FireEngineWeb.FallbackController

  def index(conn, %{"name" => name} = params) do
    page = Assessments.list_fe_quizzes_by_name(name)
                 |> Repo.paginate(params)
    render(conn, "index.html", fe_quizzes: page.entries, page: page)
  end

  def index(conn, params) do
    page = Assessments.list_fe_quizzes
                 |> Repo.paginate(params)
    render(conn, "index.html", fe_quizzes: page.entries, page: page)
  end

  def new(conn, _params) do
    changeset = Assessments.change_quiz(%Quiz{})
    render conn, "new.html", changeset: changeset
  end

  def edit(conn, %{"id" => quiz_id}) do
    quiz = Assessments.get_quiz_with_questions(quiz_id)
    changeset = Assessments.change_quiz(quiz)
    render conn, "edit.html", changeset: changeset, quiz: quiz
  end

  def create(conn, %{"quiz" => quiz_params}) do

    case Assessments.create_quiz(quiz_params) do
      {:ok, %Quiz{} = quiz} ->
        conn
        |> put_flash(:info, "Created #{quiz.name}")
        |> redirect(to: quiz_path(conn,:show,quiz))
      {:error, changeset} ->
        conn
        |> put_flash(:error,  error_parser(changeset))
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Assessments.get_quiz_with_questions(id) do
      quiz = %Quiz{} ->
        render(conn, "show.html", quiz: quiz)
      nil ->
        conn
        |> put_status(:not_found)
        |> render(FireEngineWeb.ErrorView, :"404")
    end
  end

  def update(conn, %{"id" => id, "quiz" => quiz_params}) do
    quiz = Assessments.get_quiz_with_questions(id)

    case Assessments.update_quiz(quiz, quiz_params) do
      {:ok, %Quiz{} = quiz} ->
        conn
        |> put_flash(:info, "Updated #{quiz.name}")
        |> redirect(to: quiz_path(conn,:show, quiz))
      {:error, changeset} ->
        conn
        |> put_flash(:error, error_parser(changeset))
        |> render("edit.html", changeset: changeset, quiz: quiz)

    end
  end

  def delete(conn, %{"id" => id}) do
    quiz = Assessments.get_quiz!(id)
    with {:ok, %Quiz{}} <- Assessments.delete_quiz(quiz) do
      conn
      |> put_flash(:info, "Quiz Deleted")
      |> redirect(to: quiz_path(conn, :index))
    end
  end


  #Workaround for JS generated forms. 
  def error_parser(%{changes: %{questions: questions}} = changeset) do
    if questions |> Enum.any?(fn q -> List.keymember?(q.errors,:answers,0) end) do
      "Answer weights cannot exceed total question points"
    else
      "Check your submission"
    end
  end

  def error_parser(changeset), do: "Check your submission"



end
