defmodule JsonCorpWeb.Playgrounds.FormLive do
  use JsonCorpWeb, :live_view

  defmodule Routine do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field :name, :string
      field :time, :time
    end

    @required [:name, :time]
    def changeset(%__MODULE__{} = struct \\ %__MODULE__{}, attrs) do
      struct
      |> cast(attrs, @required)
      |> validate_required(@required)
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    form =
      Routine.changeset(%{})
      |> to_form(as: :routine)

    socket =
      socket
      |> assign(:routines, [])
      |> assign(:form, form)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <form>
        <label for="hour">Time(Hour)</label>
        <select id="hour" name="hour" phx-change="select_hour">
          <%= Phoenix.HTML.Form.options_for_select(1..24, nil) %>
        </select>
      </form>
      <.simple_form for={@form} phx-change="validate" phx-submit="submit">
        <.input type="text" field={@form[:name]} label="Name" />
        <.input type="hidden" field={@form[:time]} />
        <:actions>
          <.button type="submit" class="btn" disabled={!@form.source.valid?}>Submit</.button>
        </:actions>
      </.simple_form>

      <div>
        <div :for={routine <- @routines}>
          <p><%= routine.name %></p>
          <p><%= routine.time %></p>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"routine" => params}, socket) do
    form =
      Routine.changeset(params)
      |> Map.put(:action, :validate)
      |> to_form(as: :routine)

    socket =
      socket
      |> assign(:form, form)

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_hour", %{"hour" => hour_str}, socket) do
    time = Time.new!(hour_str |> String.to_integer(), 0, 0)

    # TODO
    name = socket.assigns.form.source.changes[:name]

    params = %{
      "name" => name,
      "time" => time
    }

    form =
      Routine.changeset(params)
      |> Map.put(:action, :validate)
      |> to_form(as: :routine)

    socket =
      socket
      |> assign(:form, form)

    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"routine" => params}, socket) do
    routine =
      Routine.changeset(params)
      |> Ecto.Changeset.apply_changes()

    socket =
      socket
      |> update(:routines, fn routines -> [routine | routines] end)

    {:noreply, socket}
  end
end