defmodule FireEngineWeb.AuthController do

  use FireEngineWeb, :controller
  plug Ueberauth

  alias Phoenix.Token
  alias Ueberauth.Strategy.CAS
  alias FireEngine.Accounts.User
  alias FireEngine.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn,_params) do
    if User.admin?(auth.info.name) do
      user_params = %{username: auth.info.name, email: auth.info.email, roles: wrap_roles(auth.credentials.other)}
      changeset = User.changeset(%User{}, user_params)
      signin(conn,changeset)
    else
      conn
      |> put_flash(:error, "Not Authorized")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def login(conn, _params) do
    conn
    |> CAS.handle_request!
  end

  defp wrap_roles(roles) do
    for n <- roles, do: Map.new(name: n)
  end


  def authenticate(conn, %{"auth" => %{"secret" => secret, "client" => client}}) do
    render conn, "token.json",
           %{token: Token.sign(secret,"client salt", client), client: client}
  end

  def signout(conn, _params) do
    conn
    |> CAS.handle_cleanup!
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end


  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok , user}
    end
  end


  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome Back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error Signing In")
        |> redirect(to: page_path(conn, :index))
    end

  end





end
