defmodule ListForm.DbSchemas.Upload do
  use Ecto.Schema
  import Ecto.Changeset
  import Logger

  alias ListForm.DbSchemas.Entry

  schema "uploads" do
    # field :test, :string
    has_many :entries, Entry
  end

  def changeset(upload, attrs \\ %{}) do
    debug("UPLOAD CHANGESET attrs: #{inspect(attrs)}")

    upload
    |> cast(attrs, [])
    |> cast_assoc(:entries, with: &Entry.changeset/2)
    |> IO.inspect()
  end
end
