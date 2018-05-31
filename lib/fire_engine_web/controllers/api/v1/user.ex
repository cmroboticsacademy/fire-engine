defmodule FireEngineWeb.Api.V1.UserController do
  use FireEngineWeb, :controller
  alias FireEngine.Accounts
  action_fallback FireEngineWeb.FallbackController

  plug FireEngine.Plugs.RequireAuth

  def show(conn,%{"id" => user_id} = params) do
    user = Accounts.get_user!(user_id)
    render(conn, "show.json",user: user)
  end

  def create(conn,%{"data" => data} = params) do
    [email, username] = [decode_data(data,"email"), decode_data(data,"username")]
    case Accounts.create_user(%{username: username, email: email}) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        user = Accounts.get_user_by_email!(email)
        render(conn, "show.json", user: user)
    end
  end

  defp decode_data(data = %{},key), do: data[key]
  defp decode_data(data, key), do: Poison.decode!(data)[key]
end
