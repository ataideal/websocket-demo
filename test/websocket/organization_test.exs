defmodule Websocket.OrganizationTest do
  use Websocket.DataCase

  alias Websocket.Organization

  describe "people" do
    alias Websocket.Organization.Person

    @valid_attrs %{name: "some name", parent: "some parent", photo: "some photo", role: "some role"}
    @update_attrs %{name: "some updated name", parent: "some updated parent", photo: "some updated photo", role: "some updated role"}
    @invalid_attrs %{name: nil, parent: nil, photo: nil, role: nil}

    def person_fixture(attrs \\ %{}) do
      {:ok, person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Organization.create_person()

      person
    end

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert Organization.list_people() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Organization.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      assert {:ok, %Person{} = person} = Organization.create_person(@valid_attrs)
      assert person.name == "some name"
      assert person.parent == "some parent"
      assert person.photo == "some photo"
      assert person.role == "some role"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organization.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      assert {:ok, %Person{} = person} = Organization.update_person(person, @update_attrs)
      assert person.name == "some updated name"
      assert person.parent == "some updated parent"
      assert person.photo == "some updated photo"
      assert person.role == "some updated role"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Organization.update_person(person, @invalid_attrs)
      assert person == Organization.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Organization.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Organization.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Organization.change_person(person)
    end
  end
end
