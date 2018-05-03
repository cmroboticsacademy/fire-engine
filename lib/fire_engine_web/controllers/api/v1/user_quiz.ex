defmodule FireEngineWeb.Api.V1.UserQuizController do
  use FireEngineWeb, :controller

  def index(conn, _params) do
    render(conn,FireEngineWeb.UserQuizView, "foo.json")
  end

end
