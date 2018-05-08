defmodule FireEngine.Plugs.SetUserApi do
  import Plug.Conn
  import Phoenix.Controller

  alias FireEngine.Repo
  alias FireEngine.Accounts.User  

  def init(_params) do
  end


  def call(conn,_params) do

    user_id = decode_data(conn.body_params["data"], "user_id")

    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      true ->
        assign(conn, :user, nil)
    end

  end


  defp decode_data(data = %{},key), do: data[key]
  defp decode_data(data, key), do: Poison.decode!(data)[key]



end
