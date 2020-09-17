defmodule FireEngineWeb.QuestionController do
  use FireEngineWeb, :controller

  alias FireEngine.Assessments
  alias FireEngine.Assessments.Quiz
  alias FireEngine.Repo
  alias FireEngine.Assessments.Question


  #plug FireEngine.Plugs.RequireAuth
  plug FireEngine.Plugs.RequireCasAuth
  plug FireEngine.Plugs.VerifyAdmin
  plug FireEngine.Plugs.CheckRequestType

  action_fallback FireEngineWeb.FallbackController

  def index(conn, params) do
    page = Assessments.list_fe_questions()
                   |> Repo.paginate(params)
    render(conn, "index.html", fe_questions: page.entries, page: page)
  end

  def new(conn, _params) do
    changeset = Assessments.change_question(%Question{})
    questionTags = nil
    tags = Assessments.list_fe_tags
    render conn, "new.html", changeset: changeset, tags: tags, questionTags: questionTags
  end

  def edit(conn, %{"id" => question_id}) do
    question = Assessments.get_question!(question_id) |> Repo.preload(:quizzes)
    questionTags = question.tags |> Enum.map(&(&1.id))
    changeset = Assessments.change_question(question)
    tags = Assessments.list_fe_tags()
    render conn, "edit.html", changeset: changeset, questionTags: questionTags, tags: tags, question: question
  end

  def create(conn, %{"question" => question_params}) do
    question_params = question_params
    |> Map.put("question_tags", question_params["question_tags"] |> Enum.map(&(%{"tag_id" => &1})))

    with {:ok, %Question{} = question} <- Assessments.create_question(question_params) do
      conn
      |> put_flash(:info, "Question Added!")
      |> redirect(to: question_path(conn,:show,question))
    end
  end

  def show(conn, %{"id" => id}) do
    question = Assessments.get_question!(id) 
    render(conn, "show.html", question: question)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do

    question_params = question_params
    |> Map.put("question_tags", question_params["question_tags"] |> Enum.map(&(%{"tag_id" => &1})))

    question = Assessments.get_question!(id)

    with {:ok, %Question{} = question} <- Assessments.update_question(question, question_params) do
      question_updated = Assessments.get_question!(question.id)
      render(conn, "show.html", question: question_updated)
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
