defmodule FireEngine.AssessmentsTest do
  use FireEngine.DataCase

  alias FireEngine.Assessments

  describe "fe_quizzes" do
    alias FireEngine.Assessments.Quiz

    @valid_attrs %{attempts_allowed: 42, description: "some description", name: "some name", questions_per_page: 2, randomize_questions: true, time_closed: ~N[2010-04-17 14:00:00.000000], time_open: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{attempts_allowed: 43, description: "some updated description", name: "some updated name", questions_per_page: 43, randomize_questions: false,  time_closed: ~N[2011-05-18 15:01:01.000000], time_open: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{attempts_allowed: nil, description: nil, name: nil, questions_per_page: nil, randomize_questions: nil, time_closed: nil, time_open: nil}

    def quiz_fixture(attrs \\ %{}) do
      {:ok, quiz} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Assessments.create_quiz()

      quiz
    end

    test "quiz_total_points returns total available points for quiz" do
      question = question_fixture()
      quiz = quiz_fixture()
      Assessments.create_quiz_question(%{question_id: question.id, quiz_id: quiz.id})

      assert Assessments.quiz_total_points(quiz.id) == question.points
    end

    test "get_quiz_with_questions_paginated/2 returns only the questions from the page requested" do
      quiz = quiz_fixture()
      questions = for q <- (1..4) do
        question_fixture(%{content: "question#{q}", type: "multi"})
      end

      for q <- questions do
        Assessments.create_quiz_question(%{quiz_id: quiz.id, question_id: q.id})
      end

      quiz_questions = Assessments.get_quiz_with_questions(quiz.id).questions

      paginated_questions_pg1 = Assessments.get_quiz_with_questions_paginated(quiz.id,0)
      paginated_questions_pg2 = Assessments.get_quiz_with_questions_paginated(quiz.id,1)

      assert paginated_questions_pg1 != paginated_questions_pg2
      assert paginated_questions_pg1 |> Enum.count == 2
      assert paginated_questions_pg2 |> Enum.count == 2

    end

    test "list_fe_quizzes/0 returns all fe_quizzes" do
      quiz = quiz_fixture()
      assert Assessments.list_fe_quizzes() == [quiz]
    end

    test "get_quiz!/1 returns the quiz with given id" do
      quiz = quiz_fixture()
      assert Assessments.get_quiz!(quiz.id) == quiz
    end

    test "create_quiz/1 with valid data creates a quiz" do
      assert {:ok, %Quiz{} = quiz} = Assessments.create_quiz(@valid_attrs)
      assert quiz.attempts_allowed == 42
      assert quiz.description == "some description"
      assert quiz.name == "some name"
      assert quiz.questions_per_page == 2
      assert quiz.randomize_questions == true
      assert quiz.time_closed == ~N[2010-04-17 14:00:00.000000]
      assert quiz.time_open == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_quiz/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assessments.create_quiz(@invalid_attrs)
    end

    test "update_quiz/2 with valid data updates the quiz" do
      quiz = quiz_fixture()
      assert {:ok, quiz} = Assessments.update_quiz(quiz, @update_attrs)
      assert %Quiz{} = quiz
      assert quiz.attempts_allowed == 43
      assert quiz.description == "some updated description"
      assert quiz.name == "some updated name"
      assert quiz.questions_per_page == 43
      assert quiz.randomize_questions == false
      assert quiz.time_closed == ~N[2011-05-18 15:01:01.000000]
      assert quiz.time_open == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_quiz/2 with invalid data returns error changeset" do
      quiz = quiz_fixture()
      assert {:error, %Ecto.Changeset{}} = Assessments.update_quiz(quiz, @invalid_attrs)
      assert quiz == Assessments.get_quiz!(quiz.id)
    end

    test "delete_quiz/1 deletes the quiz" do
      quiz = quiz_fixture()
      assert {:ok, %Quiz{}} = Assessments.delete_quiz(quiz)
      assert_raise Ecto.NoResultsError, fn -> Assessments.get_quiz!(quiz.id) end
    end

    test "change_quiz/1 returns a quiz changeset" do
      quiz = quiz_fixture()
      assert %Ecto.Changeset{} = Assessments.change_quiz(quiz)
    end
  end

  describe "fe_questions" do
    alias FireEngine.Assessments.Question

    @valid_attrs %{content: "some content", points: 120.5, type: "some type", answers: [%{answer: "some answer", weight: 1.0}, %{answer: "some other answer", weight: 0.0}]}
    @update_attrs %{content: "some updated content", points: 456.7, type: "some updated type"}
    @invalid_attrs %{content: nil, points: nil, type: nil}


    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Assessments.create_question()

      question |> Repo.preload(:answers)
    end

    test "list_fe_questions/0 returns all fe_questions" do
      question = question_fixture()
      assert Assessments.list_fe_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Assessments.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Assessments.create_question(@valid_attrs)
      assert question.content == "some content"
      assert question.points == 120.5
      assert question.type == "some type"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assessments.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, question} = Assessments.update_question(question, @update_attrs)
      assert %Question{} = question
      assert question.content == "some updated content"
      assert question.points == 456.7
      assert question.type == "some updated type"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Assessments.update_question(question, @invalid_attrs)
      assert question == Assessments.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Assessments.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Assessments.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Assessments.change_question(question)
    end
  end

  describe "fe_answers" do
    alias FireEngine.Assessments.Answer

    @valid_attrs %{answer: "some answer", weight: 1}
    @update_attrs %{answer: "some updated answer",weight: 0}
    @invalid_attrs %{answer: nil, weight: nil}

    def answer_fixture(attrs \\ %{}) do
      {:ok, answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Assessments.create_answer()

      answer
    end

    test "list_fe_answers/0 returns all fe_answers" do
      answer = answer_fixture()
      assert Assessments.list_fe_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Assessments.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      assert {:ok, %Answer{} = answer} = Assessments.create_answer(@valid_attrs)
      assert answer.answer == "some answer"
      assert answer.weight == 1
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assessments.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      assert {:ok, answer} = Assessments.update_answer(answer, @update_attrs)
      assert %Answer{} = answer
      assert answer.answer == "some updated answer"
      assert answer.weight == 0
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Assessments.update_answer(answer, @invalid_attrs)
      assert answer == Assessments.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Assessments.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Assessments.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Assessments.change_answer(answer)
    end
  end

  describe "fe_attempts" do
    alias FireEngine.Assessments.Attempt
    alias FireEngine.Accounts


    @valid_attrs %{closed: false, closes: ~N[2010-04-17 14:00:00.000000], point_percent: 74.5, open: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{closed: false, closes: ~N[2011-05-18 15:01:01.000000], point_percent: 56.7, open: ~N[2011-05-18 15:01:01.000000]}
    @user %{email: "some email", username: "some username"}



    def attempt_fixture(attrs \\ %{}) do
      {:ok, attempt} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Assessments.create_attempt()

      attempt
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@user)
        |> Accounts.create_user()

      user
    end

    test "has_open_attempt?/2 returns {:ok, attempt_id} if an existing attempt is open for that user" do
      quiz = quiz_fixture()
      user = user_fixture()
      attempt = attempt_fixture(%{quiz_id: quiz.id, user_id: user.id})

      Assessments.has_open_attempt?(user.id, quiz.id)  == {:ok, attempt.id}

    end

    test "has_open_attempt?/1 returns false if an existing attempt is closed" do
      quiz = quiz_fixture()
      user = user_fixture()
      attempt = attempt_fixture(%{quiz_id: quiz.id, user_id: user.id, closed: true})

      assert Assessments.has_open_attempt?(user.id,quiz.id) == nil

    end

    test "has_open_attempt?/1 returns false if no attempts are open for user" do
      quiz = quiz_fixture()
      user = user_fixture()

      assert Assessments.has_open_attempt?(user.id, quiz.id) == nil

    end


    test "list_fe_attempts/0 returns all fe_attempts" do
      quiz = quiz_fixture()
      attempt = attempt_fixture(%{quiz_id: quiz.id})
      assert Assessments.list_fe_attempts() == [attempt]
    end

    test "get_attempt!/1 returns the attempt with given id" do
      quiz = quiz_fixture()
      attempt = attempt_fixture(%{quiz_id: quiz.id})
      assert Assessments.get_attempt!(attempt.id) == attempt
    end

    test "create_attempt/1 with valid data creates a attempt" do
      quiz = quiz_fixture()
      attempt_attrs = Map.merge(@valid_attrs, %{quiz_id: quiz.id})
      assert {:ok, %Attempt{} = attempt} = Assessments.create_attempt(attempt_attrs)
      assert attempt.closed == false
      assert attempt.closes == ~N[2010-04-17 14:00:00.000000]
      assert attempt.point_percent == 74.5
      assert attempt.open == ~N[2010-04-17 14:00:00.000000]
    end


    test "update_attempt/2 with valid data updates the attempt" do
      quiz = quiz_fixture()
      attempt = attempt_fixture(%{quiz_id: quiz.id})
      assert {:ok, attempt} = Assessments.update_attempt(attempt, @update_attrs)
      assert %Attempt{} = attempt
      assert attempt.closed == false
      assert attempt.closes == ~N[2011-05-18 15:01:01.000000]
      assert attempt.point_percent == 56.7
      assert attempt.open == ~N[2011-05-18 15:01:01.000000]
      assert attempt.start_time == attempt.inserted_at
    end


    test "delete_attempt/1 deletes the attempt" do
      quiz = quiz_fixture()
      attempt = attempt_fixture(%{quiz_id: quiz.id})
      assert {:ok, %Attempt{}} = Assessments.delete_attempt(attempt)
      assert_raise Ecto.NoResultsError, fn -> Assessments.get_attempt!(attempt.id) end
    end

    test "change_attempt/1 returns a attempt changeset" do
      quiz = quiz_fixture()
      attempt = attempt_fixture(%{quiz_id: quiz.id})
      assert %Ecto.Changeset{} = Assessments.change_attempt(attempt)
    end

    test "attempt_earned_points returns points earned within the attempt" do
      #Create Quiz
      question = question_fixture()
      quiz = quiz_fixture()
      Assessments.create_quiz_question(%{question_id: question.id, quiz_id: quiz.id})

      #Create Attempt
      {:ok,attempt} = Assessments.create_attempt(%{quiz_id: quiz.id})

      #Save answer
      answer = hd(question.answers)
      saved_response = attempt.responses
      |> hd
      |> Assessments.update_response(%{answer_id: answer.id})

      assert Assessments.attempt_earned_points(attempt.id) == (answer.weight * question.points)

    end
  end


end
