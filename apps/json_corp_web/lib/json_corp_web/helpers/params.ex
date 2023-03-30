defmodule JsonCorpWeb.Helpers.Params do
  alias JsonCorp.Core.{Nillable, Boolean}

  def to_params(form_or_changeset, more_params \\ nil)

  def to_params(%Phoenix.HTML.Form{source: %Ecto.Changeset{} = changeset}, more_params) do
    to_params(changeset, more_params)
  end

  def to_params(%Ecto.Changeset{} = changeset, more_params) do
    changeset.params
    |> Nillable.run(more_params, &(&1 |> Map.merge(more_params)))
  end

  def to_form(params, module_or_changeset_fun, opts \\ [])

  def to_form(params, module, opts) when is_atom(module) do
    to_form(params, &module.changeset/1, opts)
  end

  def to_form(params, changeset_fun, opts) when is_function(changeset_fun, 1) do
    {validate, opts} = opts |> Keyword.pop(:validate, true)

    params
    |> changeset_fun.()
    |> Boolean.run(validate, &(&1 |> Map.put(:action, :validate)))
    |> Phoenix.Component.to_form(opts)
  end
end
