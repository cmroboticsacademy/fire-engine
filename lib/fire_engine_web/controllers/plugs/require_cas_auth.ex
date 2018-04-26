defmodule FireEngine.Plugs.RequireCasAuth do

  import Plug.Conn
  import Phoenix.Controller

  alias FireEngineWeb.Router.Helpers
  alias Ueberauth.Strategy.CAS
  alias Phoenix.Token

  def init(_params) do

  end

  def call(conn, _params)do
    if conn.assigns[:user] || is_json?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt() #Do not continue with controller plug. Halt all further activity and serve page
    end
  end


  defp is_json?(conn) do
    %{path_info: path} = conn
    hd(path) == "api"
  end




end
