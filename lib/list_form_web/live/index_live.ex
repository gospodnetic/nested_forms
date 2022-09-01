defmodule ListFormWeb.IndexLive do
  use ListFormWeb, :live_view

  import Logger

  alias ListForm.DbSchemas.{Upload, Entry}

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      Upload.changeset(%Upload{}, %{
        entries: [
          %{name: "name", animal: "animal"},
          %{name: "name", animal: "animal"},
          %{name: "name", animal: "animal"}
        ]
      })

    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"upload" => %{"animal" => animal, "name" => name}}, socket) do
    debug("name: #{name}, animal: #{animal}")

    changeset =
      Upload.changeset(%Upload{}, %{
        entries: [
          %{name: name, animal: animal},
          %{name: name, animal: animal},
          %{name: name, animal: animal}
        ]
      })

    debug(inspect(changeset))
    {:noreply, socket}
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
      |> Ecto.Changeset.put_assoc(:entries, entries)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <div class="container p-0">
      <h1>List Form</h1>

        <.form let={f} for={@changeset} phx-change="validate" phx-submit="submit">
          <%= label f, :name %>
          <%= text_input f, :name, phx_debounce: 1000 %>
          <%= label f, :animal %>
          <%= text_input f, :animal %>

          <%= inputs_for f, :entries, fn v -> %>
            <div class="flex flex-wrap -mx-1 overflow-hidden">
              <div class="form-group px-1 w-3/6">
                <%= label v, :name %>
                <%= text_input v, :name, class: "form-control" %>
                <%= error_tag v, :name %>
              </div>

              <div class="form-group px-1 w-2/6">
                <%= label v, :animal %>
                <%= text_input v, :animal, class: "form-control" %>
                <%= error_tag v, :animal %>
              </div>
            </div>
          <% end %>
        </.form>
        <button phx-click="add_entry">Add entry</button>
      </div>
    """
  end
end
