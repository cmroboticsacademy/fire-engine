defmodule FireEngine.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Accounts.Role


  schema "fe_roles" do
    field :user_id, :id
    field :name, :string

    timestamps(usec: false)
  end


  @doc false
  def changeset(%Role{} = role, attrs) do
    role
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name])
  end
end
