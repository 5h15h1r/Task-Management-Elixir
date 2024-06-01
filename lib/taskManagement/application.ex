defmodule TaskManagement.Application do
  use Application

  def start(_type, _args) do
    children = [
      TaskManagement.TaskDB,
      TaskManagementWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: TaskManagement.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TaskManagementWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
