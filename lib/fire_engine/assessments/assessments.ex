defmodule FireEngine.Assessments do
  @moduledoc """
  The Assessments context.
  """

  import Ecto.Query, warn: false
  alias FireEngine.Repo

  alias FireEngine.Assessments.Quiz

  @doc """
  Returns quiz with questions included.

  ## Examples

      iex> get_quiz_with_questions()
      [%Quiz{}, ...]

  """
  def get_quiz_with_questions(id) do
    Repo.get(Quiz, id) |> Repo.preload(questions: :answers)
  end

  def get_quiz_with_questions(id,page) do
    quiz = Repo.get(Quiz, id) |> Repo.preload(questions: :answers)
    questions = quiz.questions
    |> Scrivener.paginate(%Scrivener.Config{page_number: page, page_size: quiz.questions_per_page})
    {quiz, questions}
  end


  @doc """
  Returns quiz with questions and user responses included.

  ## Examples

      iex> get_quiz_with_responses()
      [%Quiz{}, ...]

  """
  def get_quiz_with_responses(id) do
    FireEngine.Repo.get(Quiz,id) |> Repo.preload(questions: [answers: :responses])
  end

  def quiz_total_points(quiz_id) do
    query = from qz in Quiz,
    join: q in assoc(qz, :questions),
    where: qz.id == ^quiz_id,
    select: q.points

    query
    |> Repo.all
    |> Enum.sum
  end

  def quiz_total_user_attempts(quiz_id, user_id) do
    query = from qz in Quiz,
    join: a in assoc(qz, :attempts),
    where: qz.id == ^quiz_id and a.user_id == ^user_id

    query |> Repo.all |> Enum.count
  end




  @doc """
  Returns the list of fe_quizzes.

  ## Examples

      iex> list_fe_quizzes()
      [%Quiz{}, ...]

  """
  def list_fe_quizzes do
    Repo.all(Quiz) |> Repo.preload(:questions)
  end



  @doc """
  Gets a single quiz.

  Raises `Ecto.NoResultsError` if the Quiz does not exist.

  ## Examples

      iex> get_quiz!(123)
      %Quiz{}

      iex> get_quiz!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quiz!(id), do: Repo.get!(Quiz, id, preload: :questions) |> Repo.preload(:questions)

  @doc """
  Creates a quiz.

  ## Examples

      iex> create_quiz(%{field: value})
      {:ok, %Quiz{}}

      iex> create_quiz(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quiz(attrs \\ %{}) do
    changeset = %Quiz{}
    |> Repo.preload(:questions)
    |> Quiz.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quiz.

  ## Examples

      iex> update_quiz(quiz, %{field: new_value})
      {:ok, %Quiz{}}

      iex> update_quiz(quiz, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quiz(%Quiz{} = quiz, attrs) do
    quiz
    |> Quiz.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Quiz.

  ## Examples

      iex> delete_quiz(quiz)
      {:ok, %Quiz{}}

      iex> delete_quiz(quiz)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quiz(%Quiz{} = quiz) do
    Repo.delete(quiz)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quiz changes.

  ## Examples

      iex> change_quiz(quiz)
      %Ecto.Changeset{source: %Quiz{}}

  """
  def change_quiz(%Quiz{} = quiz) do
    quiz
    |> Repo.preload(questions: :answers)
    |> Quiz.changeset(%{})
  end

  alias FireEngine.Assessments.Question

  @doc """
  Returns the list of fe_questions.

  ## Examples

      iex> list_fe_questions()
      [%Question{}, ...]

  """
  def list_fe_questions do
    Repo.all(Question) |> Repo.preload([:answers,:tags])
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id) |> Repo.preload([:answers,:tags])

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{source: %Question{}}

  """
  def change_question(%Question{} = question) do
    question
    |> Repo.preload(:answers)
    |> Question.changeset(%{})
  end

  alias FireEngine.Assessments.Answer

  @doc """
  Returns the list of fe_answers.

  ## Examples

      iex> list_fe_answers()
      [%Answer{}, ...]

  """
  def list_fe_answers do
    Repo.all(Answer)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{source: %Answer{}}

  """
  def change_answer(%Answer{} = answer) do
    Answer.changeset(answer, %{})
  end


  alias FireEngine.Assessments.Attempt

  @doc """
  Returns the list of fe_attempts.

  ## Examples

      iex> list_fe_attempts()
      [%Attempt{}, ...]

  """
  def list_fe_attempts do
    Repo.all(Attempt) |> Repo.preload(:responses)
  end

  def list_quizzes_with_attempts(user_id) do
    user_attempts = from a in Attempt,
    where: a.user_id == ^user_id and a.closed == true

    query = from q in Quiz,
    left_join: a in subquery(user_attempts), on: [quiz_id: q.id],
    group_by: q.id,
    group_by: q.name,
    group_by: q.description,
    group_by: q.questions_per_page,
    group_by: q.attempts_allowed,
    select: %{id: q.id,name: q.name, description: q.description, attempts_allowed: q.attempts_allowed, questions_per_page: q.questions_per_page, attempt_count: count(a.id), best_score: max(a.point_percent), avg_score: avg(a.point_percent), lowest_score: min(a.point_percent)}

    query |> Repo.all

  end


  def attempt_earned_points(attempt_id) do
    query = from a in Attempt,
    join: r in assoc(a, :responses),
    join: q in Question, on: [id: r.question_id],
    join: an in Answer, on: [id: r.answer_id],
    where: a.id == ^attempt_id,
    select: %{points: q.points, weight: an.weight}

    earned_points = query
    |> Repo.all
    |> Enum.map(fn x -> x.weight * x.points end)
    |> Enum.sum
  end

  @doc """
  Gets a single attempt.

  Raises `Ecto.NoResultsError` if the Attempt does not exist.

  ## Examples

      iex> get_attempt!(123)
      %Attempt{}

      iex> get_attempt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attempt!(id), do: Repo.get!(Attempt, id) |> Repo.preload(:responses)



    @doc """
    Gets an attempt with responses.

    Raises `Ecto.NoResultsError` if the Attempt does not exist.

    ## Examples

        iex> get_attempt_with_responses(123)
        %Attempt{}

        iex> get_attempt_with_responses(456)
        ** (Ecto.NoResultsError)

    """
    def get_attempt_with_responses(id), do: Repo.get!(Attempt, id) |> Repo.preload(:responses)


    def get_attempt_with_responses(id, page) do
       attempt = Repo.get!(Attempt, id)
                 |> Repo.preload(:responses)
       quiz = Repo.get!(Quiz,attempt.quiz_id)
       responses = attempt.responses
                   |> Scrivener.paginate(%Scrivener.Config{page_number: page, page_size: quiz.questions_per_page})
       {attempt, responses}
    end



    def get_attempt_in_quiz_form(id) do
      query = from a in Attempt,
      join: qz in Quiz, on: [id: a.quiz_id],
      join: r in assoc(a, :responses),
      join: q in Question, on: [id: r.question_id],
      join: an in Answer, on: [id: r.answer_id],
      where: a.id == ^id,
      select: %{attempt: a.id, quiz: qz.name, question: q.content, answer: an.answer}

      query
      |> Repo.all
    end


  @doc """
  Creates a attempt.

  ## Examples

      iex> create_attempt(%{field: value})
      {:ok, %Attempt{}}

      iex> create_attempt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attempt(attrs) do

      {:ok, attempt} = %Attempt{}
      |> Attempt.changeset(attrs)
      |> Repo.insert()

      attempt = update_attempt(attempt,%{start_time: attempt.inserted_at })

      create_responses_for_attempt(attempt)
  end

  def has_open_attempt?(user_id, quiz_id) do
      query = from a in Attempt,
      where: a.user_id == ^user_id and a.closed != true and a.quiz_id == ^quiz_id

      open_attempts = query |> Repo.all

      cond do
        (open_attempts |> Enum.any?) ->
          {:ok, hd(open_attempts).id }
        true ->
          nil
      end

  end


  defp create_responses_for_attempt({:ok, attempt} = params) do
    quiz = get_quiz!(attempt.quiz_id)

    for q <- quiz.questions do
      create_response(%{attempt_id: attempt.id, question_id: q.id})
    end

    {:ok,get_attempt!(attempt.id) |> Repo.preload(:responses)}

  end

  @doc """
  Updates a attempt.

  ## Examples

      iex> update_attempt(attempt, %{field: new_value})
      {:ok, %Attempt{}}

      iex> update_attempt(attempt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attempt(%Attempt{} = attempt, attrs) do
    attempt
    |> Repo.preload(:responses)
    |> Attempt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Attempt.

  ## Examples

      iex> delete_attempt(attempt)
      {:ok, %Attempt{}}

      iex> delete_attempt(attempt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attempt(%Attempt{} = attempt) do
    Repo.delete(attempt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attempt changes.

  ## Examples

      iex> change_attempt(attempt)
      %Ecto.Changeset{source: %Attempt{}}

  """
  def change_attempt(%Attempt{} = attempt) do
    Attempt.changeset(attempt, %{})
  end

  alias FireEngine.Assessments.Response

  @doc """
  Returns the list of fe_responses.

  ## Examples

      iex> list_fe_responses()
      [%Response{}, ...]

  """
  def list_fe_responses do
    Repo.all(Response)
  end

  @doc """
  Gets a single response.

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response!(123)
      %Response{}

      iex> get_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_response!(id), do: Repo.get!(Response, id)

  @doc """
  Creates a response.

  ## Examples

      iex> create_response(%{field: value})
      {:ok, %Response{}}

      iex> create_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_response(attrs \\ %{}) do
    %Response{}
    |> Response.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a response.

  ## Examples

      iex> update_response(response, %{field: new_value})
      {:ok, %Response{}}

      iex> update_response(response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_response(%Response{} = response, attrs) do
    response
    |> Response.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Response.

  ## Examples

      iex> delete_response(response)
      {:ok, %Response{}}

      iex> delete_response(response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_response(%Response{} = response) do
    Repo.delete(response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking response changes.

  ## Examples

      iex> change_response(response)
      %Ecto.Changeset{source: %Response{}}

  """
  def change_response(%Response{} = response) do
    Response.changeset(response, %{})
  end

  alias FireEngine.Assessments.QuizQuestion

  @doc """
  Returns the list of fe_quiz_questions.
  ## Examples
      iex> list_fe_quiz_questions()
      [%QuizQuestion{}, ...]
  """
  def list_fe_quiz_questions do
    Repo.all(QuizQuestion)
  end

  @doc """
  Gets a single quiz_question.
  Raises `Ecto.NoResultsError` if the Quiz question does not exist.
  ## Examples
      iex> get_quiz_question!(123)
      %QuizQuestion{}
      iex> get_quiz_question!(456)
      ** (Ecto.NoResultsError)
  """
  def get_quiz_question!(id), do: Repo.get!(QuizQuestion, id)

  @doc """
  Creates a quiz_question.
  ## Examples
      iex> create_quiz_question(%{field: value})
      {:ok, %QuizQuestion{}}
      iex> create_quiz_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_quiz_question(attrs \\ %{}) do
    %QuizQuestion{}
    |> QuizQuestion.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quiz_question.
  ## Examples
      iex> update_quiz_question(quiz_question, %{field: new_value})
      {:ok, %QuizQuestion{}}
      iex> update_quiz_question(quiz_question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_quiz_question(%QuizQuestion{} = quiz_question, attrs) do
    quiz_question
    |> QuizQuestion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a QuizQuestion.
  ## Examples
      iex> delete_quiz_question(quiz_question)
      {:ok, %QuizQuestion{}}
      iex> delete_quiz_question(quiz_question)
      {:error, %Ecto.Changeset{}}
  """
  def delete_quiz_question(%QuizQuestion{} = quiz_question) do
    Repo.delete(quiz_question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quiz_question changes.
  ## Examples
      iex> change_quiz_question(quiz_question)
      %Ecto.Changeset{source: %QuizQuestion{}}
  """
  def change_quiz_question(%QuizQuestion{} = quiz_question) do
    QuizQuestion.changeset(quiz_question, %{})
  end



  alias FireEngine.Assessments.Category

  @doc """
  Returns the list of fe_categories.

  ## Examples

      iex> list_fe_categories()
      [%Category{}, ...]

  """
  def list_fe_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  alias FireEngine.Assessments.Tag

  @doc """
  Returns the list of fe_tags.

  ## Examples

      iex> list_fe_tags()
      [%Tag{}, ...]

  """
  def list_fe_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{source: %Tag{}}

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end

  alias FireEngine.Assessments.QuestionTag

  @doc """
  Returns the list of fe_question_tags.

  ## Examples

      iex> list_fe_question_tags()
      [%QuestionTag{}, ...]

  """
  def list_fe_question_tags do
    Repo.all(QuestionTag)
  end

  @doc """
  Gets a single question_tag.

  Raises `Ecto.NoResultsError` if the Question tag does not exist.

  ## Examples

      iex> get_question_tag!(123)
      %QuestionTag{}

      iex> get_question_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question_tag!(id), do: Repo.get!(QuestionTag, id)

  @doc """
  Creates a question_tag.

  ## Examples

      iex> create_question_tag(%{field: value})
      {:ok, %QuestionTag{}}

      iex> create_question_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question_tag(attrs \\ %{}) do
    %QuestionTag{}
    |> QuestionTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question_tag.

  ## Examples

      iex> update_question_tag(question_tag, %{field: new_value})
      {:ok, %QuestionTag{}}

      iex> update_question_tag(question_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question_tag(%QuestionTag{} = question_tag, attrs) do
    question_tag
    |> QuestionTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a QuestionTag.

  ## Examples

      iex> delete_question_tag(question_tag)
      {:ok, %QuestionTag{}}

      iex> delete_question_tag(question_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question_tag(%QuestionTag{} = question_tag) do
    Repo.delete(question_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question_tag changes.

  ## Examples

      iex> change_question_tag(question_tag)
      %Ecto.Changeset{source: %QuestionTag{}}

  """
  def change_question_tag(%QuestionTag{} = question_tag) do
    QuestionTag.changeset(question_tag, %{})
  end

end
