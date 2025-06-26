defmodule JsonCorp.External do
  @callback base_url() :: String.t() | nil
  @callback default_headers() :: list(tuple())
  @callback auth(auth_param :: any()) :: any()
  @callback handle_response({:ok, %Req.Response{}} | {:error, any()}) ::
              {:ok, map()} | {:error, any()}

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)
      import unquote(__MODULE__)

      require Logger
      alias JsonCorp.Core.Ok

      @impl true
      def base_url() do
        nil
      end

      @impl true
      def default_headers() do
        []
      end

      @impl true
      def auth(nil) do
        nil
      end

      defoverridable base_url: 0, default_headers: 0
    end
  end

  require Logger
  alias JsonCorp.Core.ModuleHelper

  defmacro request(method, path, opts \\ []) do
    {headers_param, opts} = opts |> Keyword.pop(:headers, [])
    {auth_param, opts} = opts |> Keyword.pop(:auth, nil)
    {base_url_param, opts} = opts |> Keyword.pop(:base_url, nil)
    %{module: module, function: {fun_name, fun_arity}} = __CALLER__
    caller = [module, fun_name, fun_arity]

    quote do
      Req.new(headers: unquote(headers_param) ++ default_headers())
      |> Req.merge(
        method: unquote(method),
        base_url: unquote(base_url_param) || base_url(),
        url: unquote(path)
      )
      |> Req.merge(auth: auth(unquote(auth_param)))
      |> Req.merge(unquote(opts))
      |> tap(
        &Logger.debug(
          "#{unquote(__MODULE__).inspect_caller(unquote(caller))} request: #{inspect(&1)}"
        )
      )
      |> Req.request()
      |> tap(
        &Logger.debug(
          "#{unquote(__MODULE__).inspect_caller(unquote(caller))} response: #{inspect(&1)}"
        )
      )
      |> handle_response()
      |> unquote(__MODULE__).log_error_response(unquote(caller))
    end
  end

  def log_error_response({:ok, _} = result, _caller) do
    result
  end

  def log_error_response({:error, error}, caller) do
    Logger.warning("#{inspect_caller(caller)}: #{inspect(error)}")

    {:error, error}
  end

  def inspect_caller([module, fun_name, fun_arity]) do
    "[#{ModuleHelper.to_string(module)}] #{fun_name}/#{fun_arity}"
  end

  def reject_nil_params(params) do
    params
    |> Map.reject(fn {_, value} -> is_nil(value) end)
  end
end
