defmodule FireEngineWeb.PageController do
  use FireEngineWeb, :controller


  def index(conn, _params) do
    render conn, "index.html"
  end

  def notauthorized(conn, _params) do
    render conn, "notauthorized.json"
  end



end
