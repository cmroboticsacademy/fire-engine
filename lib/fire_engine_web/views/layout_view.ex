defmodule FireEngineWeb.LayoutView do
  use FireEngineWeb, :view

  def logged_in?(conn) do
    conn.assigns[:user]
  end

  def admin_user?(conn) do
    # Placeholder
    conn.assigns[:user].username
    |> FireEngine.Accounts.User.admin?
  end

end
