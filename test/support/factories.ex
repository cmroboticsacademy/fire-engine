defmodule FireEngine.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: FireEngine.Repo

  alias FireEngine.Assessments
  alias FireEngine.Accounts


  def quiz_factory do
    %Assessments.Quiz{
      name: "Quiz",
      description: "a description",
      attempts_allowed: 2,
      randomize_questions: true,
      questions_per_page: 5
    }
  end

  def question_factory do
    %Assessments.Question{
      content: "How do you do?",
      type: "MultiChoice",
      points: 1.0,
      answers: [build(:answer)]
    }

  end


  def answer_factory do
    %Assessments.Answer {
      answer: "what he said",
      weight: 1.0
    }
  end

  def user_factory do
    %Accounts.User{
      username: "someuser",
      email: "someuser@email.com"
    }
  end


end
