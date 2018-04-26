defmodule FireEngine.Plugs.RequireAuth do

  import Plug.Conn
  import Phoenix.Controller

  alias FireEngineWeb.Router.Helpers
  alias Phoenix.Token

  def init(_params) do

  end

  def call(conn, _params)do
    secret = System.get_env("API_SECRET")
    if conn.params["token"] do
      case Token.verify(secret,"client salt", conn.params["token"],max_age: 86400) do
        {:ok, _client_id} ->
          conn
        {:error, _client_id} ->
          notauthorized(conn)
      end
    else
      notauthorized(conn)
    end
  end

  defp notauthorized(conn) do
    conn
    |> redirect(to: Helpers.page_path(conn, :notauthorized))
    |> halt()
  end

end
