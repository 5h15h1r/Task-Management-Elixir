defmodule TaskManagementWeb.TaskController do
  use TaskManagementWeb, :controller

  alias TaskManagement.TaskDB

  def create_user(conn, _params) do
    {:ok, user_id} = TaskDB.create_user()

    conn
    |> put_status(:created)
    |> json(%{user_id: user_id})
  end

  def create_task(conn, %{"user_id" => user_id, "task" => task}) do
    user_id = String.to_integer(user_id)

    case TaskDB.user_exists?(user_id) do
      true ->
        case TaskDB.create_task(user_id, task) do
          {:ok, task_id} ->
            conn
            |> put_status(:created)
            |> json(%{task_id: task_id})

          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end

      false ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User ID does not exist"})
    end
  end

  def get_tasks(conn, %{"user_id" => user_id}) do
    user_id = String.to_integer(user_id)

    case TaskDB.user_exists?(user_id) do
      true ->
        tasks = TaskDB.get_tasks(user_id)
        json(conn, %{data: tasks})

      false ->
        conn
        # 404 Not Found
        |> put_status(:not_found)
        |> json(%{error: "User ID does not exist"})
    end
  end

  def get_task(conn, %{"user_id" => user_id, "task_id" => task_id}) do
    user_id = String.to_integer(user_id)

    case TaskDB.user_exists?(user_id) do
      true ->
        task_id = String.to_integer(task_id)

        case TaskDB.task_exists?(user_id, task_id) do
          true ->
            task = TaskDB.get_task(user_id, task_id)

            conn
            |> json(%{data: task})

          false ->
            conn
            # 404 Not Found
            |> put_status(:not_found)
            |> json(%{error: "Task ID does not exist"})
        end

      false ->
        conn
        # 404 Not Found
        |> put_status(:not_found)
        |> json(%{error: "User ID does not exist"})
    end
  end

  def update_task(conn, %{"user_id" => user_id, "task_id" => task_id, "task" => task}) do
    user_id = String.to_integer(user_id)

    case TaskDB.user_exists?(user_id) do
      true ->
        task_id = String.to_integer(task_id)

        case TaskDB.task_exists?(user_id, task_id) do
          true ->
            {:ok, :updated} = TaskDB.update_task(user_id, task_id, task)
            send_resp(conn, :no_content, "")

          false ->
            conn
            # 404 Not Found
            |> put_status(:not_found)
            |> json(%{error: "Task ID does not exist"})
        end

      false ->
        conn
        # 404 Not Found
        |> put_status(:not_found)
        |> json(%{error: "User ID does not exist"})
    end
  end

  def delete_task(conn, %{"user_id" => user_id, "task_id" => task_id}) do
    user_id = String.to_integer(user_id)
    task_id = String.to_integer(task_id)

    case TaskDB.user_exists?(user_id) do
      true ->
        case TaskDB.task_exists?(user_id, task_id) do
          true ->
            {:ok, :deleted} = TaskDB.delete_task(user_id, task_id)
            send_resp(conn, :no_content, "")

          false ->
            conn
            # 404 Not Found
            |> put_status(:not_found)
            |> json(%{error: "Task ID does not exist"})
        end

      false ->
        conn
        # 404 Not Found
        |> put_status(:not_found)
        |> json(%{error: "User ID does not exist"})
    end
  end
end
