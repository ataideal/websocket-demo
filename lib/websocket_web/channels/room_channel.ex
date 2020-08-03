defmodule WebsocketWeb.RoomChannel do
  use WebsocketWeb, :channel

  alias Websocket.Organization
  alias WebsocketWeb.PersonView

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      people = Organization.list_people()
      {:ok, PersonView.render("index.json", %{people: people}), socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  @impl true
  def handle_in("new_person", payload, socket) do
    with {:ok, person} <- Organization.create_person(payload) do
      broadcast socket, "new_person", PersonView.render("person.json", %{person: person})
      {:noreply, socket}
    else 
      _ -> {:reply, {:error, nil}, socket}
    end
  end

  @impl true
  def handle_in("delete_person", %{"id" =>id }, socket) do
    with {:ok, person} <- Organization.delete_person(id) do
      broadcast socket, "delete_person", PersonView.render("person.json", %{person: person})
      {:noreply, socket}
    else 
      _ -> {:reply, {:error, nil}, socket}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
