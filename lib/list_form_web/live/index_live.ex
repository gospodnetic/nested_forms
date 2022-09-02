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

    {_reply, changeset} = Changeset.apply_action(changeset, :insert)
    debug(inspect(changeset))
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add_entry", _, socket) do
    vars = Map.get(socket.assigns.changeset.changes, :entries)

    debug("ADD ENTRY: #{inspect(vars)}")

    entries =
      vars
      |> Enum.concat([
        Entry.changeset(%Entry{})
      ])

    changeset =
      socket.assigns.changeset
      |> Changeset.put_assoc(:entries, entries)

    {_reply, changeset} = Changeset.apply_action(changeset, :insert)

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
            <div style="border: 1px solid #ccc; margin-top: 1rem; padding: 0.5rem;">
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
            </div>
          <% end %>
        </.form>
        <button phx-click="add_entry">Add a pet</button>
      </div>
    """
  end
end
