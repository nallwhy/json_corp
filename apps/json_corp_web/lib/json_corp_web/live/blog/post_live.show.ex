defmodule JsonCorpWeb.Blog.PostLive.Show do
  use JsonCorpWeb, :live_view
  use JsonCorp.Blog
  alias JsonCorp.Blog.MarkdownRenderer
  alias JsonCorp.Stats
  alias Doumi.Phoenix.Params

  @impl true
  def mount(%{"language" => language, "slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign(:blog_language, language)
      |> assign(:slug, slug)
      |> init_comment_form()
      |> load_post()
      |> load_comments()
      |> assign(:comment_id, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    socket =
      socket
      |> assign_async(:view_count, fn ->
        normalized_uri =
          uri |> URI.parse() |> Map.merge(%{fragment: nil, query: nil}) |> URI.to_string()

        view_count =
          cond do
            Regex.match?(~r{/blog/ko/}, normalized_uri) ->
              old_uri = Regex.replace(~r{/blog/ko}, normalized_uri, "/blog")

              [
                load_view_count(normalized_uri),
                load_view_count(old_uri),
                load_view_count(Regex.replace(~r{/blog/ko}, normalized_uri, "/blog/en")),
                load_view_count(String.replace(normalized_uri, "-", "_")),
                load_view_count(String.replace(old_uri, "-", "_"))
              ]
              |> Enum.sum()

            Regex.match?(~r{/blog/en/}, normalized_uri) ->
              old_uri = Regex.replace(~r{/blog/en}, normalized_uri, "/blog")

              [
                load_view_count(normalized_uri),
                load_view_count(old_uri),
                load_view_count(Regex.replace(~r{/blog/en}, normalized_uri, "/blog/ko")),
                load_view_count(String.replace(normalized_uri, "-", "_")),
                load_view_count(String.replace(old_uri, "-", "_"))
              ]
              |> Enum.sum()

            true ->
              load_view_count(normalized_uri)
          end

        {:ok, %{view_count: view_count}}
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("unlock_post", %{"door" => %{"password" => password}}, socket) do
    socket =
      case socket.assigns.post.password do
        ^password ->
          socket
          |> assign(:locked, false)

        _ ->
          socket
          |> put_flash(:error, "Denied")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate_comment", %{"comment" => inputs}, socket) do
    socket =
      socket
      |> validate_comment_form(inputs)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save_comment", _params, socket) do
    params = socket.assigns.comment_form |> Params.to_map()

    {:ok, comment} = Blog.create_comment(params)

    socket =
      socket
      |> init_comment_form()
      |> stream_insert(:comments, comment)

    {:noreply, socket}
  end

  @impl true
  def handle_event("set_comment_id", %{"comment_id" => comment_id}, socket) do
    socket =
      socket
      |> assign(:comment_id, comment_id)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_comment", %{"comment_id" => comment_id_str, "email" => email}, socket) do
    comment_id = comment_id_str |> String.to_integer()

    socket =
      case Blog.delete_comment(comment_id, email) do
        {:ok, comment} ->
          socket
          |> stream_delete(:comments, comment)
          |> put_flash(:info, "Comment deleted")

        {:error, _} ->
          socket
          |> put_flash(:error, "Failed to delete comment")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:view_count, view_count}, socket) do
    socket =
      socket
      |> assign(:view_count, view_count)

    {:noreply, socket}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(%{locked: true} = assigns) do
    ~H"""
    <.form :let={f} for={:door} phx-submit="unlock_post">
      <.input
        type="password"
        field={f[:password]}
        class="input input-bordered"
        placeholder="password"
      />

      <button class="btn">Open</button>
    </.form>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="pb-4">
      <.link navigate={~p"/blog/#{@language}"} class="block mb-6">
        <Icon.arrow_left class="icon mr-1" /><span class="text-gray-400">{gettext("Back to posts")}</span>
      </.link>
      <div class="prose">
        <h1>{@post.title}</h1>
        <p>{@post.description}</p>
        <div><time>{gettext("Date created")}: {@post.date_created}</time></div>
        <div>
          {gettext("View count")}:
          <.async_result :let={view_count} assign={@view_count}>
            <:loading>-</:loading>
            {view_count}
          </.async_result>
        </div>
      </div>
      <div :if={@post.tags} class="mt-2">
        <.link :for={tag <- @post.tags} navigate={~p"/blog/#{@post.language}?tag=#{tag}"}>
          <span class="mr-2 tag">#{tag}</span>
        </.link>
      </div>
    </div>
    <hr class="prose" />
    <div class="prose pt-4">
      <img :if={@post.cover_url} src={@post.cover_url} alt={@post.title} class="w-full" />
      {@post.body |> MarkdownRenderer.html() |> raw()}
    </div>
    <div :if={false} class="max-w-2xl mt-12">
      <.h2>Comments</.h2>
      <.simple_form for={@comment_form} phx-change="validate_comment" phx-submit="save_comment">
        <div class="flex space-x-8">
          <.input class="flex-1" type="text" field={@comment_form[:name]} label="Name" />
          <.input
            class="flex-1"
            type="email"
            field={@comment_form[:email]}
            label="Email"
            placeholder="It will not be displayed to other users."
          />
        </div>
        <.input type="textarea" field={@comment_form[:body]} />

        <:actions>
          <.button disabled={!@comment_form.source.valid?} phx-disable-with="Saving...">
            Save
          </.button>
        </:actions>
      </.simple_form>
      <div id="comments" phx-update="stream" class="mt-4 divide-y-2">
        <div
          :for={{comment_dom_id, %Comment{} = comment} <- @streams.comments}
          id={comment_dom_id}
          class="py-4 space-y-2"
        >
          <p>{comment.name}</p>
          <p>{comment.inserted_at |> ago()}</p>
          <p>{comment.body}</p>
          <.button phx-click={
            JS.push("set_comment_id", value: %{comment_id: comment.id})
            |> show_modal("comment-delete-modal")
          }>
            Delete
          </.button>
        </div>
      </div>
    </div>
    <.modal id="comment-delete-modal">
      <.simple_form
        :let={f}
        for={%{}}
        phx-submit={JS.push("delete_comment") |> hide_modal("comment-delete-modal")}
      >
        <p class="font-bold">
          Please enter the email you used to post in order to delete your comment.
        </p>
        <.input type="hidden" field={f[:comment_id]} value={@comment_id} />
        <.input type="text" field={f[:email]} label="email" autocomplete="off" />
        <:actions>
          <.button>Confirm</.button>
        </:actions>
      </.simple_form>
    </.modal>
    """
  end

  defp load_post(socket) do
    case Blog.fetch_post(
           socket.assigns.language,
           socket.assigns.blog_language,
           socket.assigns.slug
         ) do
      {:ok, post} ->
        case post.language == socket.assigns.blog_language do
          true ->
            socket
            |> assign(:post, post)
            |> assign_new(:locked, fn
              %{post: %SecretPost{}} -> true
              %{post: %Post{}} -> false
            end)
            |> assign_new(:page_meta, fn %{
                                           post: %Post{
                                             title: title,
                                             description: description,
                                             cover_url: cover_url,
                                             tags: tags
                                           }
                                         } ->
              %{
                title: title,
                description: description,
                image: cover_url,
                keyword: tags
              }
            end)

          false ->
            socket
            |> push_navigate(to: ~p"/blog/#{socket.assigns.language}/#{post.slug}", replace: true)
        end

      _ ->
        socket
        |> push_navigate(to: ~p"/blog/#{socket.assigns.language}", replace: true)
    end
  end

  defp load_comments(socket) do
    {:ok, comments} =
      Blog.list_comments(%{post_slug: socket.assigns.slug, session_id: socket.assigns.session_id})

    socket
    |> stream(:comments, comments)
  end

  def load_view_count(uri) do
    Stats.get_view_count_by_uri(uri)
  end

  defp init_comment_form(socket) do
    socket
    |> assign(
      :comment_form,
      Params.to_form(
        %Comment{},
        %{post_slug: socket.assigns.slug, session_id: socket.assigns.session_id},
        with: &Comment.Command.changeset_for_create/2,
        validate: false
      )
    )
  end

  defp validate_comment_form(socket, inputs) do
    params =
      socket.assigns.comment_form
      |> Params.to_params(inputs)

    comment_form =
      Params.to_form(%Comment{}, params, with: &Comment.Command.changeset_for_create/2)

    socket
    |> assign(:comment_form, comment_form)
  end
end
