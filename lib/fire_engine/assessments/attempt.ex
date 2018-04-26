defmodule FireEngine.Assessments.Attempt do
  use Ecto.Schema
  import Ecto.Changeset
  alias FireEngine.Assessments.Attempt


  schema "fe_attempts" do
    field :closed, :boolean, default: false
    field :closes, :naive_datetime
    field :point_percent, :float
    field :point_total, :float
    field :points_available, :float
    field :open, :naive_datetime
    field :user_id, :id
    field :quiz_id, :id
    field :start_time, :naive_datetime

    has_many :responses, FireEngine.Assessments.Response, on_delete: :delete_all
    has_one :quiz, FireEngine.Assessments.Quiz

    timestamps(usec: false)
  end

  @doc false
  def changeset(%Attempt{} = attempt, attrs) do
    attempt
    |> cast(attrs, [:open, :closes, :point_percent, :point_total, :points_available, :closed,:user_id, :quiz_id, :start_time])
    |> cast_assoc(:responses)
  end

end
