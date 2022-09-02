defmodule ListFormWeb.IndexLive do
  use ListFormWeb, :live_view

  import Logger

  alias Ecto.Changeset
  alias ListForm.DbSchemas.{Upload, Entry}

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      Upload.changeset(%Upload{}, %{
        entries: []
      })

    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"upload" => %{"entries" => entries}}, socket) do
    debug("entries: #{inspect(entries)}")

    changeset =
      Upload.changeset(%Upload{}, %{
        entries: entries
      })

    {:noreply, assign(socket, changeset: %{changeset | action: :insert})}
  end

  def handle_event("add_entry", _, socket) do
    entries =
      Map.get(socket.assigns.changeset.changes, :entries)
      |> Enum.concat([
        Entry.changeset(%Entry{})
      ])

    changeset =
      socket.assigns.changeset
      |> Changeset.put_assoc(:entries, entries)

    {:noreply, assign(socket, changeset: %{changeset | action: :insert})}
  end

  def handle_event("cancel_upload", %{"idx" => idx}, socket) do
    {idx, ""} = Integer.parse(idx)

    entries =
      Map.get(socket.assigns.changeset.changes, :entries)
      |> List.delete_at(idx)

    changeset =
      socket.assigns.changeset
      |> Changeset.put_assoc(:entries, entries)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <div class="container">
      <h1>List Form</h1>
        Give all your pets a shoutout!
        <.form let={f} for={@changeset} phx-change="validate" phx-submit="submit">
          <%= inputs_for f, :entries, fn v -> %>
            <div style="border: 1px solid #ccc; margin-top: 1rem; padding: 0.5rem; position: relative;">
              <div style="width: 40%; display: inline-block; vertical-align: top">
                <%= label v, :name %>
                <%= text_input v, :name, class: "form-control", phx_debounce: 1000 %>
                <%= error_tag v, :name %>
              </div>

              <div style="width: 40%; display: inline-block">
                <%= label v, :animal %>
                <%= text_input v, :animal, class: "form-control", phx_debounce: 1000 %>
                <%= error_tag v, :animal %>
              </div>
              <button type="button" phx-click="cancel_upload" phx-value-idx={v.index} style="position: absolute; top: 0; right: 0; border-radius: 0;">&times;</button>
            </div>
          <% end %>
        </.form>
        <button phx-click="add_entry">Add a pet</button>
      </div>
    """
  end
end
