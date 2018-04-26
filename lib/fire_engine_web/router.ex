defmodule FireEngineWeb.Router do
  use FireEngineWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug FireEngine.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FireEngineWeb do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index

    get "/u/quizzes", UserQuizController, :index

    get "/login", AuthController, :login
    get "/auth/cas/callback", AuthController, :callback
    get "/logout", AuthController, :signout


    put "/u/attempts/save/:id", UserAttemptController, :save

    resources "/u/attempts", UserAttemptController
    resources "/admin/quizzes", QuizController
    resources "/admin/questions", QuestionController
  end

  # Other scopes may use custom stacks.
    scope "/api/v1", FireEngineWeb do
      pipe_through :api
      get "/not_authorized", PageController, :notauthorized
      get "/authenticate", AuthController, :authenticate
    end
end
