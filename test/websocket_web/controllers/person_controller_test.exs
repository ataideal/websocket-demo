defmodule WebsocketWeb.PersonControllerTest do
  use WebsocketWeb.ConnCase

  alias Websocket.Organization
  alias Websocket.Organization.Person

  @create_attrs %{
    name: "some name",
    parent: "some parent",
    photo: "some photo",
    role: "some role"
  }
  @update_attrs %{
    name: "some updated name",
    parent: "some updated parent",
    photo: "some updated photo",
    role: "some updated role"
  }
  @invalid_attrs %{name: nil, parent: nil, photo: nil, role: nil}

  def fixture(:person) do
    {:ok, person} = Organization.create_person(@create_attrs)
    person
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all people", %{conn: conn} do
      conn = get(conn, Routes.person_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create person" do
    test "renders person when data is valid", %{conn: conn} do
      conn = post(conn, Routes.person_path(conn, :create), person: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.person_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "parent" => "some parent",
               "photo" => "some photo",
               "role" => "some role"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.person_path(conn, :create), person: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update person" do
    setup [:create_person]

    test "renders person when data is valid", %{conn: conn, person: %Person{id: id} = person} do
      conn = put(conn, Routes.person_path(conn, :update, person), person: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.person_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "parent" => "some updated parent",
               "photo" => "some updated photo",
               "role" => "some updated role"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, person: person} do
      conn = put(conn, Routes.person_path(conn, :update, person), person: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete person" do
    setup [:create_person]

    test "deletes chosen person", %{conn: conn, person: person} do
      conn = delete(conn, Routes.person_path(conn, :delete, person))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.person_path(conn, :show, person))
      end
    end
  end

  defp create_person(_) do
    person = fixture(:person)
    %{person: person}
  end
end
