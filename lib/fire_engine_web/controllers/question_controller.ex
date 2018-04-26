defmodule FireEngineWeb.QuestionController do
  use FireEngineWeb, :controller

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Quiz
  alias FireEngine.Assessments.Question


  #plug FireEngine.Plugs.RequireAuth
  plug FireEngine.Plugs.RequireCasAuth
  plug FireEngine.Plugs.VerifyAdmin
  plug FireEngine.Plugs.CheckRequestType

  action_fallback FireEngineWeb.FallbackController

  def index(conn, _params) do
    fe_questions = Assessments.list_fe_questions()
    render(conn, "index.html", fe_questions: fe_questions)
  end

  def new(conn, _params) do
    changeset = Assessments.change_question(%Question{})
    render conn, "new.html", changeset: changeset
  end

  def edit(conn, %{"id" => question_id}) do
    question = Assessments.get_question!(question_id)
    changeset = Assessments.change_question(question)
    render conn, "edit.html", changeset: changeset, question: question
  end

  def create(conn, %{"question" => question_params}) do
    with {:ok, %Question{} = question} <- Assessments.create_question(question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", question_path(conn, :show, question))
      |> render("show.html", question: question)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Assessments.get_question!(id)
    render(conn, "show.html", question: question)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Assessments.get_question!(id)

    with {:ok, %Question{} = question} <- Assessments.update_question(question, question_params) do
      render(conn, "show.html", question: question)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Assessments.get_question!(id)
    with {:ok, %Question{}} <- Assessments.delete_question(question) do
      conn
      |> put_flash(:info, "Question Deleted!")
      |> redirect(to: question_path(conn, :index))
    end
  end
end
