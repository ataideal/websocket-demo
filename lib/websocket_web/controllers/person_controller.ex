defmodule WebsocketWeb.PersonController do
  use WebsocketWeb, :controller

  alias Websocket.Organization
  alias Websocket.Organization.Person
  alias WebsocketWeb.PersonView

  action_fallback WebsocketWeb.FallbackController

  def index(conn, _params) do
    people = Organization.list_people()
    render(conn, "index.json", people: people)
  end

  def create(conn, %{"person" => person_params}) do
    with {:ok, %Person{} = person} <- Organization.create_person(person_params) do
      WebsocketWeb.Endpoint.broadcast "room:lobby", "new_person", PersonView.render("person.json", %{person: person})
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.person_path(conn, :show, person))
      |> render("show.json", person: person)
    end
  end

  def show(conn, %{"id" => id}) do
    person = Organization.get_person!(id)
    render(conn, "show.json", person: person)
  end

  def update(conn, %{"id" => id, "person" => person_params}) do
    person = Organization.get_person!(id)

    with {:ok, %Person{} = person} <- Organization.update_person(person, person_params) do
      render(conn, "show.json", person: person)
    end
  end

  def delete(conn, %{"id" => id}) do
    person = Organization.get_person!(id)

    with {:ok, %Person{}} <- Organization.delete_person(person) do
      send_resp(conn, :no_content, "")
    end
  end
end
