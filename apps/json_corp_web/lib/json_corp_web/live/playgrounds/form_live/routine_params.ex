defmodule JsonCorpWeb.Playgrounds.FormLive.RoutineParams do
  use Ecto.Schema
  use Doumi.Phoenix.Params, as: :routine
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :time, :time

    embeds_many :steps, Step, primary_key: false, on_replace: :delete do
      field :description, :string
    end
  end

  @required [:name, :time]
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> cast_embed(:steps,
      with: &step_changeset/2,
      sort_param: :step_order,
      drop_param: :step_delete,
      required: true
    )
  end

  @step_required [:description]
  defp step_changeset(%__MODULE__.Step{} = struct, attrs) do
    struct
    |> cast(attrs, @step_required)
    |> validate_required(@step_required)
  end
end
