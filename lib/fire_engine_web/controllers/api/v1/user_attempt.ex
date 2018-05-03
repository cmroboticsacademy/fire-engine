defmodule FireEngineWeb.Api.V1.UserAttemptController do
  use FireEngineWeb, :controller

  def index(conn, _params) do
    render(conn,FireEngineWeb.UserAttemptView, "foo.json")
  end

end
