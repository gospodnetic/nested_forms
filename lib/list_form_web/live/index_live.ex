defmodule ListFormWeb.IndexLive do
  use ListFormWeb, :live_view

  import Logger

  alias ListForm.DbSchemas.Upload

  @impl true
  def mount(_params, _session, socket) do
    changeset = Upload.changeset(%Upload{})
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
        </.form>

      </div>
    """
  end
end
