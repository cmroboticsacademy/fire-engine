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

  def user_factory do
    %Accounts.User{
      username: "someuser",
      email: "someuser@email.com"
    }
  end


end
