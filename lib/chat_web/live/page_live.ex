defmodule ChatWeb.Live.PageLive do
  use ChatWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("random", _params, socket) do
    {:noreply, push_redirect(socket, to: "/phoenix-in-action-chat")}
  end
end
