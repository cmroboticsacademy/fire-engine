defmodule FireEngine.Plugs.CheckQuizTime do

  import Plug.Conn
  import Phoenix.Controller
  use Timex

  alias FireEngineWeb.Router.Helpers
  alias FireEngine.Assessments
  alias FireEngine.Accounts

  def init(_params) do
  end

  def call(conn,_params) do
    user_id = conn.assigns.user.id
    quiz = get_quiz(conn)

    unless quiz.time_limit == false do
      user = Accounts.get_user!(user_id)
      case quiz_open?(quiz,user) do
        true ->
          conn
        false ->
          FireEngineWeb.Plug.Helpers.close_attempt(user_id,quiz.id)
          conn
          |> put_flash(:info, "Your current attempt has expired")
          |> redirect(to: Helpers.user_quiz_path(conn,:index))
          |> halt()
      end
    else
      conn
    end

  end


  defp quiz_open?(quiz,user) do
    case Assessments.has_open_attempt?(user.id,quiz.id) do
      {:ok, attempt_id} ->
        attempt = Assessments.get_attempt!(attempt_id)
        interval = Timex.Interval.new(from: attempt.start_time, until: [minutes: quiz.time_limit_minutes])
        if Timex.now in interval do
          true
        else
          false
        end
      nil ->
        true
    end
  end


  defp get_quiz(%{query_params: params} = conn) when params != %{} do
    Assessments.get_quiz!(params["quiz_id"])
  end

  defp get_quiz(%{params: params} = conn) do
    quiz_id = decode_data(params["data"], "quiz_id")
    Assessments.get_quiz!(quiz_id)
  end


  defp decode_data(data = %{},key), do: data[key]
  defp decode_data(data, key), do: Poison.decode!(data)[key]


end
