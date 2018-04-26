defmodule FireEngine.Plugs.VerifyAdmin do

  import Plug.Conn
  import Phoenix.Controller

  alias FireEngineWeb.Router.Helpers
  alias FireEngine.Accounts.User

  def init(_params) do

  end

  def call(conn, _params)do

    if User.admin?(conn.assigns[:user].username) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to view this page!")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt() #Do not continue with controller plug. Halt all further activity and serve page
    end
  end


  defp is_json?(conn) do
    %{path_info: path} = conn
    hd(path) == "api"
  end




end
