defmodule TaskManagement.TaskDB do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def create_user() do
    Agent.update(__MODULE__, fn state ->
      user_id = Enum.count(state) + 1
      Map.put(state, user_id, %{})
    end)

    {:ok, Enum.count(Agent.get(__MODULE__, & &1))}
  end

  def create_task(user_id, task) do
    Agent.update(__MODULE__, fn state ->
      tasks = Map.get(state, user_id, %{})
      task_id = Enum.count(tasks) + 1
      updated_tasks = Map.put(tasks, task_id, task)
      Map.put(state, user_id, updated_tasks)
    end)

    {:ok, Enum.count(Agent.get(__MODULE__, fn state -> Map.get(state, user_id) end))}
  end

  def user_exists?(user_id) do
    Agent.get(__MODULE__, fn state ->
      Map.has_key?(state, user_id)
    end)
  end

  def get_tasks(user_id) do
    Agent.get(__MODULE__, fn state -> Map.get(state, user_id, %{}) end)
  end

  def task_exists?(user_id, task_id) do
    Agent.get(__MODULE__, fn state ->
      taskMap = Map.get(state, user_id)
      Map.has_key?(taskMap, task_id)
    end)
  end

  def get_task(user_id, task_id) do
    Agent.get(__MODULE__, fn state ->
      tasks = Map.get(state, user_id, %{})
      Map.get(tasks, task_id)
    end)
  end

  def update_task(user_id, task_id, updated_task) do
    Agent.update(__MODULE__, fn state ->
      tasks = Map.get(state, user_id, %{})
      updated_tasks = Map.put(tasks, task_id, updated_task)
      Map.put(state, user_id, updated_tasks)
    end)

    {:ok, :updated}
  end

  def delete_task(user_id, task_id) do
    Agent.update(__MODULE__, fn state ->
      tasks = Map.get(state, user_id, %{})
      updated_tasks = Map.delete(tasks, task_id)
      Map.put(state, user_id, updated_tasks)
    end)

    {:ok, :deleted}
  end
end
