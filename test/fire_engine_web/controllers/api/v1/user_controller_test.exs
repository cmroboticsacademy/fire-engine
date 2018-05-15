# Create this test in test/controllers/todo_controller_test.exs
defmodule FireEngine.UserControllerTest do
  import Plug.Test
  import FireEngine.Factory
  alias FireEngine.Accounts

  use FireEngineWeb.ConnCase

  test "#show returns a user" do
    conn = build_conn()
    user = insert(:user)

    conn = get conn, "api/v1/users/#{user.id}"
    assert json_response(conn, 200) == %{
      "data" => %{
        "id" => user.id,
        "username" => user.username,
        "email" => user.email
        }
    }
  end

  test "#create returns a newly generated user for the username provided" do
    conn = build_conn()
    user = build(:user)

    json_data = Poison.encode! %{username: user.username, email: user.email}

    conn = post conn, "api/v1/users/", [data: json_data]


    assert user_db = Accounts.list_fe_users |> Enum.find(&(&1.username == user.username))

    assert json_response(conn, 200) == %{
      "data" => %{
        "id" => user_db.id ,
        "username" => user_db.username,
        "email" => user_db.email
      }
    }


  end

  test "#create returns the existing user if the same username or email has been requested" do
    conn = build_conn()
    user = insert(:user)
    json_data = Poison.encode! %{username: user.username, email: user.email}

    conn = post conn, "api/v1/users/", [data: json_data]

    assert json_response(conn, 200) == %{
      "data" => %{
        "id" => user.id,
        "username" => user.username,
        "email" => user.email
      }
    }

    assert (Accounts.list_fe_users |> Enum.count) == 1

  end

end
