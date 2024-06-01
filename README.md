# Task Management
![Elixir](https://miro.medium.com/v2/resize:fit:700/0*s3Grgk1uw2YaVC2S.png)
This is a Phoenix application that provides an API for managing tasks associated with users. It allows you to create users, create tasks for a user, retrieve tasks for a user, retrieve a specific task for a user, update a task for a user, and delete a task for a user. The application uses an Agent HashMap to store and manage the data.

## Dependencies

- Elixir
- Phoenix

## Agent HashMap

The application uses an Agent HashMap to store and manage the data for tasks and users. An Agent is a simple abstraction around a state that is managed by a process. The Agent HashMap provides a key-value store functionality, where the keys are the user IDs, and the values are maps containing the user's tasks.

The Agent HashMap is implemented in the `TaskManagement.TaskDB` module, which provides the following functions:

- `start_link/0`: Starts the Agent HashMap process.
- `create_user/0`: Creates a new user and returns the user's ID.
- `create_task/2`: Creates a new task for the specified user and returns the task's ID.
- `get_tasks/1`: Retrieves all tasks for the specified user.
- `get_task/2`: Retrieves a specific task for the specified user.
- `update_task/3`: Updates a specific task for the specified user.
- `delete_task/2`: Deletes a specific task for the specified user.
- `user_exists?/1`: Checks if a user with the specified ID exists.
- `task_exists?/2`: Checks if a task with the specified ID exists for the specified user.

## Routes

The following routes are available:

- `POST /users`: Create a new user.
- `POST /users/:user_id/tasks`: Create a new task for the specified user.
- `GET /users/:user_id/tasks`: Retrieve all tasks for the specified user.
- `GET /users/:user_id/tasks/:task_id`: Retrieve a specific task for the specified user.
- `PUT /users/:user_id/tasks/:task_id`: Update a specific task for the specified user.
- `DELETE /users/:user_id/tasks/:task_id`: Delete a specific task for the specified user.

## Usage

To run the application, follow these steps:

1. Clone the repository.
2. Install dependencies with `mix deps.get`.
3. Start the Phoenix server with `mix phx.server`.Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The application should now be running, and you can make requests to the endpoints using tools like Postman or cURL.

## Testing

The application includes unit tests for the `TaskController`. You can run the tests with the following command:

```
mix test
```