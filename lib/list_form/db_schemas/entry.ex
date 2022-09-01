defmodule ListForm.DbSchemas.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  import Logger

  schema "entries" do
    field :name, :string
    field :animal, :string
    belongs_to :upload, ListForm.DbSchemas.Upload
  end

  def changeset(entry, attrs \\ %{}) do
    debug("ENTRY CHANGESET attrs: #{inspect(attrs)}")

    entry
    |> cast(attrs, [:name, :animal])
    |> validate_required([:name, :animal])
    |> IO.inspect()
  end
end
