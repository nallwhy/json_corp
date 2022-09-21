defmodule JsonCorp.Stats.ViewLog do
  use JsonCorp.Model

  schema "view_logs" do
    field :session_id, Ecto.UUID
    field :uri, :string
    field :created_at, :utc_datetime_usec
  end

  @required_for_create [:session_id, :uri, :created_at]
  def changeset_for_create(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_for_create)
    |> validate_required(@required_for_create)
  end

  def create(params) do
    %__MODULE__{}
    |> changeset_for_create(params)
  end
end
