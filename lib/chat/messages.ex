defmodule Chat.Messages do


  def subscribe(topic) do
    Phoenix.PubSub.subscribe(Chat.PubSub, topic)
    # room_id  I need to listen this channel
  end

  def broadcast({:error, _reason} = error, _event), do: error

  def broadcast(topic, "new-message", message) do
    IO.inspect("Broadcast!")
    Phoenix.PubSub.broadcast(Chat.PubSub, topic, {"new-message", message})
  end
end
