defmodule FireEngine.Plugs.CheckQuizWindow do

  import Plug.Conn
  import Phoenix.Controller
  use Timex

  alias FireEngineWeb.Router.Helpers
  alias FireEngine.Assessments
  alias FireEngine.Accounts
  alias FireEngine.Assessments.Attempt

  def init(_params) do
  end

  def call(conn,_params) do
    user_id = conn.assigns.user.id
    quiz = get_quiz(conn)

    unless quiz.time_window == false do
      case quiz_open?(quiz) do
        true ->
          conn
        false ->
          FireEngineWeb.Plug.Helpers.close_attempt(user_id,quiz.id)
          conn
          |> put_flash(:info,"This quiz is only open between #{quiz.time_open} and #{quiz.time_closed}")
          |> redirect(to: Helpers.user_quiz_path(conn,:index))
          |> halt() #Do not continue with controller plug. Halt all further activity and serve page
      end
    else
      conn
    end
  end


  defp quiz_open?(quiz) do
    interval = Timex.Interval.new(from: quiz.time_open, until: quiz.time_closed)
    Timex.today in interval
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
