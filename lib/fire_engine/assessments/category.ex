defmodule FireEngine.Assessments.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Assessments.Category


  schema "fe_categories" do
    field :name, :string
    #field :parent_id, :integer

    has_many :questions, FireEngine.Assessments.Question
    belongs_to :parent, Category, foreign_key: :parent_id
    has_many :children, Category, foreign_key: :parent_id

    timestamps(usec: false)
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name, :parent_id])
    |> validate_required([:name])
  end



end
