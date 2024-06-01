defmodule TaskManagementWeb.TaskControllerTest do
  use TaskManagementWeb.ConnCase, async: true

  alias TaskManagement.TaskDB

  setup do
    {:ok, user_id} = TaskDB.create_user()
    {:ok, task_id} = TaskDB.create_task(user_id, "Test Task")
    %{user_id: user_id, task_id: task_id}
  end

  describe "POST /users" do
    test "creates a new user", %{conn: conn} do
      conn = post(conn, "/api/users")
      assert json_response(conn, 201)["user_id"]
    end
  end

  describe "POST /users/:user_id/tasks" do
    test "creates a new task for the specified user", %{conn: conn, user_id: user_id} do
      conn = post(conn, "/api/users/#{user_id}/tasks", %{task: "New Task"})
      assert json_response(conn, 201)["task_id"]
    end

    test "returns 404 when user does not exist", %{conn: conn} do
      conn = post(conn, "/api/users/999/tasks", %{task: "New Task"})
      assert json_response(conn, 404)["error"] == "User ID does not exist"
    end
  end

  describe "GET /users/:user_id/tasks" do
    test "retrieves tasks for the specified user", %{conn: conn, user_id: user_id} do
      conn = get(conn, "/api/users/#{user_id}/tasks")
      assert json_response(conn, 200)["data"]
    end

    test "returns 404 when user does not exist", %{conn: conn} do
      conn = get(conn, "/api/users/999/tasks")
      assert json_response(conn, 404)["error"] == "User ID does not exist"
    end
  end

  describe "GET /users/:user_id/tasks/:task_id" do
    test "retrieves a specific task for the specified user", %{
      conn: conn,
      user_id: user_id,
      task_id: task_id
    } do
      conn = get(conn, "/api/users/#{user_id}/tasks/#{task_id}")
      assert json_response(conn, 200)["data"]
    end

    test "returns 404 when user does not exist", %{conn: conn, task_id: task_id} do
      conn = get(conn, "/api/users/999/tasks/#{task_id}")
      assert json_response(conn, 404)["error"] == "User ID does not exist"
    end

    test "returns 404 when task does not exist", %{conn: conn, user_id: user_id} do
      conn = get(conn, "/api/users/#{user_id}/tasks/999")
      assert json_response(conn, 404)["error"] == "Task ID does not exist"
    end
  end

  describe "PUT /users/:user_id/tasks/:task_id" do
    test "updates a specific task for the specified user", %{
      conn: conn,
      user_id: user_id,
      task_id: task_id
    } do
      conn = put(conn, "/api/users/#{user_id}/tasks/#{task_id}", %{task: "Updated Task"})
      assert response(conn, 204)
    end

    test "returns 404 when user does not exist", %{conn: conn, task_id: task_id} do
      conn = put(conn, "/api/users/999/tasks/#{task_id}", %{task: "Updated Task"})
      assert json_response(conn, 404)["error"] == "User ID does not exist"
    end

    test "returns 404 when task does not exist", %{conn: conn, user_id: user_id} do
      conn = put(conn, "/api/users/#{user_id}/tasks/999", %{task: "Updated Task"})
      assert json_response(conn, 404)["error"] == "Task ID does not exist"
    end
  end

  describe "DELETE /users/:user_id/tasks/:task_id" do
    test "deletes a specific task for the specified user", %{
      conn: conn,
      user_id: user_id,
      task_id: task_id
    } do
      conn = delete(conn, "/api/users/#{user_id}/tasks/#{task_id}")
      assert response(conn, 204)
    end

    test "returns 404 when user does not exist", %{conn: conn, task_id: task_id} do
      conn = delete(conn, "/api/users/999/tasks/#{task_id}")
      assert json_response(conn, 404)["error"] == "User ID does not exist"
    end

    test "returns 404 when task does not exist", %{conn: conn, user_id: user_id} do
      conn = delete(conn, "/api/users/#{user_id}/tasks/999")
      assert json_response(conn, 404)["error"] == "Task ID does not exist"
    end
  end
end
