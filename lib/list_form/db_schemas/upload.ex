defmodule ListForm.DbSchemas.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  alias ListForm.DbSchemas.Entry

  schema "uploads" do
    has_many :entries, Entry
  end

  def changeset(upload, attrs \\ %{}) do
    upload
    |> cast(attrs, [])
    |> cast_assoc(:entries, with: &Entry.changeset/2)
  end
end
