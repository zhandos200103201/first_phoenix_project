defmodule ChatWeb.Live.PageLive do
  use ChatWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("username", %{"in" => %{"username" => username}}, socket) do
    {:noreply, push_redirect(socket, to: "/private-chat-from-zhandos/" <> username)}
  end
end
