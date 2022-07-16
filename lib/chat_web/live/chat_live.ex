defmodule ChatWeb.Live.ChatLive do
  use ChatWeb, :live_view
  require Logger

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    room = "private-chat-from-zhandos"
    topic = "room: " <> room
    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(topic)
      ChatWeb.Presence.track(self(), topic, username, %{})
    end
    {:ok,
      assign(socket,
      room: room,
      topic: topic,
      username: username,
      message: "",
      messages: [],
      user_list: [],
      temporary_assigns: [messages: []]
      )}
  end

  @impl true
  def handle_event("new_message", %{"chat" => %{"message" => message}}, socket) do
    message = %{uuid: UUID.uuid4(), content: message, username: socket.assigns.username}
    ChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_event("form_updated", %{"chat" => %{"message" => message}}, socket) do
    Logger.info(message: message)
    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message], message: "")}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages =
      joins
      |>  Map.keys()
      |>  Enum.map(fn username ->
          %{ uuid: UUID.uuid4(), content: "#{username} joined", username: "system"}
        end)

    leave_messages =
      leaves
      |>  Map.keys()
      |>  Enum.map(fn username ->
          %{uuid: UUID.uuid4(), content: "#{username} left", username: "system"}
        end)

    user_list = ChatWeb.Presence.list(socket.assigns.topic) |> Map.keys()

    {:noreply, assign(socket, messages: socket.assigns.messages ++ join_messages ++ leave_messages, user_list: user_list, message: "")}
  end
end
