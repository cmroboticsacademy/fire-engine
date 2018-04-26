defmodule FireEngine.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  import Ecto.Queryable
  alias FireEngine.Accounts.User


  schema "fe_users" do
    field :email, :string
    field :username, :string

    has_many :roles, FireEngine.Accounts.Role
    has_many :attempts, FireEngine.Assessments.Attempt

    timestamps(usec: false)
  end

  def admin?(username) do
    query = from u in User,
    join: r in assoc(u, :roles),
    where: r.name == "admin" and u.username == ^username

    query
    |> FireEngine.Repo.all
    |> Enum.any?
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> cast_assoc(:roles)
  end
end
