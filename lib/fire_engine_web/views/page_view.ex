defmodule FireEngineWeb.PageView do
  use FireEngineWeb, :view

  def render("notauthorized.json", %{}) do
    %{error: "Not Authorized"}
  end
end
