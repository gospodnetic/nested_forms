defmodule ListFormWeb.PageController do
  use ListFormWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
