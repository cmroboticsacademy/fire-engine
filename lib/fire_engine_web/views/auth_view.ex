defmodule FireEngineWeb.AuthView do
  use FireEngineWeb, :view

  def render("token.json", %{token: token, client: client}) do
    %{client: client, token: token}
  end
end
