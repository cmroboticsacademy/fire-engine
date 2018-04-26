defmodule FireEngine.Plugs.CheckRequestType do

  import Plug.Conn
  import Phoenix.Controller

  alias FireEngineWeb.Router.Helpers

  def init(_params) do

  end

  def call(conn,_params) do
    %{path_info: path} = conn
    [head | _tail] = path

    if head == "api" do
      assign(conn, :request_type, "json")
    else
      assign(conn, :request_type, "html")
    end
  end

end
