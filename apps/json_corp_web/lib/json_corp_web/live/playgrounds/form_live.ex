defmodule JsonCorpWeb.Playgrounds.FormLive do
  use JsonCorpWeb, :live_view

  @code_url "https://github.com/nallwhy/json_corp/blob/main/apps/json_corp_web/lib/json_corp_web/live/playgrounds/form_live.ex"

  defmodule Routine do
    use Ecto.Schema
    use Doumi.Phoenix.Params, as: :routine
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field(:name, :string)
      field(:time, :time)

      embeds_many :steps, Step, primary_key: false, on_replace: :delete do
        field(:description, :string)
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

  @impl true
  def mount(_params, _session, socket) do
    form = Routine.to_form(%{steps: [%{}]}, validate: false)

    socket =
      socket
      |> assign(:code_url, @code_url)
      |> assign(:routines, [])
      |> assign(:form, form)
      |> assign(:hour, "")

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Form</.h1>
    <.link href={@code_url} class="underline" target="_blank">Open Code</.link>
    <div>
      <.simple_form for={%{}}>
        <.input
          label="Time(Hour)"
          type="select"
          name="hour"
          prompt="Select hour"
          options={1..24}
          value={@hour}
          phx-change="select_hour"
        />
      </.simple_form>
      <.simple_form for={@form} phx-change="validate" phx-submit="submit">
        <.input type="text" field={@form[:name]} label="Name" />
        <.input type="hidden" field={@form[:time]} />
        <p>Steps</p>
        <.inputs_for :let={step} field={@form[:steps]}>
          <input type="hidden" name="routine[step_order][]" value={step.index} />
          <div class="flex items-center">
            <.input type="text" field={step[:description]} placeholder="description" />
            <label class="block !mt-2 ml-2 cursor-pointer">
              <input type="checkbox" name="routine[step_delete][]" class="hidden" value={step.index} />
              <.icon name="hero-x-mark" />
            </label>
          </div>
        </.inputs_for>
        <label class="block !mt-2 cursor-pointer">
          <input type="checkbox" name="routine[step_order][]" class="hidden" />
          <.icon name="hero-plus-circle" />add more
        </label>
        <:actions>
          <.button type="submit" disabled={!@form.source.valid?}>Submit</.button>
        </:actions>
      </.simple_form>

      <div>
        <div :for={routine <- @routines}>
          <p><%= routine.name %></p>
          <p><%= routine.time %></p>
          <div :for={step <- routine.steps}>
            <p><%= step.description %></p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"routine" => params}, socket) do
    form = Routine.to_form(params)

    socket =
      socket
      |> assign(:form, form)

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_hour", %{"hour" => hour_str}, socket) do
    time = Time.new!(hour_str |> String.to_integer(), 0, 0)

    params =
      socket.assigns.form
      |> Params.to_params(%{"time" => time})

    form = Routine.to_form(params)

    socket =
      socket
      |> assign(:form, form)
      |> assign(:hour, hour_str)

    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"routine" => params}, socket) do
    routine =
      Routine.to_form(params)
      |> Params.to_map()

    socket =
      socket
      |> update(:routines, fn routines -> [routine | routines] end)

    {:noreply, socket}
  end
end
