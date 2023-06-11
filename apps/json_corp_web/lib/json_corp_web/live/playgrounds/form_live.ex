defmodule JsonCorpWeb.Playgrounds.FormLive do
  use JsonCorpWeb, :live_view
  alias __MODULE__.RoutineParams

  @code_url "https://github.com/nallwhy/json_corp/blob/main/apps/json_corp_web/lib/json_corp_web/live/playgrounds/form_live.ex"

  @impl true
  def mount(_params, _session, socket) do
    form = RoutineParams.to_form(%{steps: [%{}]}, validate: false)

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
        <.input type="textarea" field={@form[:description]} label="Description" />
        <div id={"#{@form[:description].id}-editor"} phx-update="ignore">
          <trix-editor input={@form[:description].id}></trix-editor>
        </div>
        <p>Steps</p>
        <.inputs_for :let={step} field={@form[:steps]}>
          <.field_adder_hidden for={step} name="routine[step_order][]" />
          <div class="flex items-center">
            <.input type="text" field={step[:description]} placeholder="description" />
            <.field_remover for={step} name="routine[step_delete][]" />
          </div>
        </.inputs_for>
        <.field_adder name="routine[step_order][]" label="add more" />
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
    form = RoutineParams.to_form(params)

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

    form = RoutineParams.to_form(params)

    socket =
      socket
      |> assign(:form, form)
      |> assign(:hour, hour_str)

    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"routine" => params}, socket) do
    routine =
      RoutineParams.to_form(params)
      |> Params.to_map()

    socket =
      socket
      |> update(:routines, fn routines -> [routine | routines] end)

    {:noreply, socket}
  end
end
