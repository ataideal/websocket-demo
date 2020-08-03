defmodule WebsocketWeb.PersonView do
  use WebsocketWeb, :view
  alias WebsocketWeb.PersonView

  def render("index.json", %{people: people}) do
    %{data: render_many(people, PersonView, "person.json")}
  end

  def render("show.json", %{person: person}) do
    %{data: render_one(person, PersonView, "person.json")}
  end
  
  def render("person.json", %{person: person}) do
    %{id: person.id,
    name: person.name,
    role: person.role,
    photo: person.photo,
    parent_id: person.parent_id}
  end

end
