defmodule Websocket.Organization.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :name, :string
    belongs_to :parent, Websocket.Organization.Person
    has_many :children, Websocket.Organization.Person, foreign_key: :parent_id
    field :photo, :string
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :role, :photo, :parent_id])
    |> validate_required([:name, :role])
    |> foreign_key_constraint(:parent_id)
  end
end
