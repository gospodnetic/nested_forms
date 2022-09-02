defmodule ListForm.Repo.Migrations.AddEntriesTable do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :name, :string
      add :animal, :string
    end
  end
end
