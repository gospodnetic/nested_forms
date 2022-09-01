defmodule ListForm.Repo do
  use Ecto.Repo,
    otp_app: :list_form,
    adapter: Ecto.Adapters.Postgres
end
