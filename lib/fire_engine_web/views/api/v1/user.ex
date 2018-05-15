defmodule FireEngineWeb.Api.V1.UserView do
  def render("show.json",%{:user => user}) do
    %{data: %{
        id: user.id,
        email: user.email,
        username: user.username
      }}
  end

end
