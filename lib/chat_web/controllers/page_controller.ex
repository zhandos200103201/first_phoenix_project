defmodule ChatWeb.PageController do
  use ChatWeb, :controller
  require Logger

  def index(conn, _params) do
    random_room = "/" <> MnemonicSlugs.generate_slug(2)
    render(conn, "index.html", room: random_room)
  end
end
