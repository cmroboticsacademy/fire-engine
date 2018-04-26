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
    %{"quiz_id" => quiz_id} = conn.query_params
    quiz = Assessments.get_quiz!(quiz_id)

    unless quiz.time_limit == false do
      user = Accounts.get_user!(user_id)
      case quiz_open?(quiz,user) do
        true ->
          conn
        false ->
          FireEngineWeb.Plug.Helpers.close_attempt(user_id,quiz_id)
          conn
          |> put_flash(:info, "This quiz has a #{quiz.time_limit_minutes} minutes limit. Your current attempt has expired")
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

end
