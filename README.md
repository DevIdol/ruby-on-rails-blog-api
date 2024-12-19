# BlogApp - Rails API with Docker, PostgreSQL 16, and pgAdmin4

## Prerequisites

Before setting up the application, make sure you have the following installed:

- [Docker](https://www.docker.com/products/docker-desktop) (for building and running the application containers)
- [Docker Compose](https://docs.docker.com/compose/) (for managing multi-container setups)
- [PostgreSQL 16](https://www.postgresql.org/download/) and [pgAdmin4](https://www.pgadmin.org/download/) for database management

---

## Connecting with pgAdmin4

To manage your PostgreSQL database via **pgAdmin4**, follow these steps:

1. Open **pgAdmin4**.
2. Create a new **server connection** with the following parameters:
   - **Host:** `localhost`
   - **Port:** `5432`
   - **Username:** `postgres`
   - **Password:** `root`

---

## Docker Commands

### Build the Docker Containers

Build the containers with the following command:

```bash
docker-compose build
```

### Start the Containers

Run the following command to start the containers in detached mode:

```bash
docker-compose up -d
```

### Re-Start the Containers

```bash
docker-compose restart web
```

### Migrate the Database

```bash
docker-compose exec web rails db:create db:migrate
```

### Stopping the Containers

```bash
docker-compose down
```

### Access the Application

Once the containers are running, access the Rails application at:

```bash
http://localhost:3000
```

---

## Generating Controllers and Models

### Generate a Controller

To generate a new controller, use the following command:

```bash
docker-compose exec web rails generate controller <controller_name> <actions>
```

Example:

```bash
docker-compose exec web rails generate controller Blog index show create update destroy
```

This command creates a controller named `BlogController` with the specified actions (`index`, `show`, `create`, `update`, `destroy`).

### Generate a Model

To generate a new model, use the following command:

```bash
docker-compose exec web rails generate model <model_name> <attribute_name>:<data_type>
```

Example:

```bash
docker-compose exec web rails generate model Blog title:string description:text user:references is_publish:boolean
```

This command creates a model named `Blog` with the following attributes:

- `title` (string)
- `description` (text)
- `user` (references another model, usually `User`)
- `is_publish` (boolean)

After generating a model, don't forget to run the migrations:

```bash
docker-compose exec web rails db:migrate
```

### Modify the Model

If the migration has already been applied, you need to generate a new migration to update the schema.

```bash
docker-compose exec web rails generate migration AddFieldToModelName field_name:data_type

docker-compose exec web rails db:migrate
```

Example:

```bash
docker-compose exec web rails generate migration AddPublishedDateToBlogs published_date:datetime

docker-compose exec web rails db:migrate
```

---

## API Endpoints

### Authentication

- **POST** `/register`

  - Registers a new user.
  - **Request Body:**
    ```json
    {
      "username": "user1",
      "email": "user1@gmail.com",
      "password": "password",
      "password_confirmation": "password"
    }
    ```

- **POST** `/login`

  - Logs in a user.
  - **Request Body:**
    ```json
    { "email": "user1@gmail.com", "password": "password" }
    ```

- **POST** `/logout`
  - Logs out the current user.

---

### User Routes

- **GET** `/users/:id`

  - Retrieves a user profile by `id`.

- **PATCH** `/users/:id`

  - Updates a user's profile.

- **DELETE** `/users/:id`
  - Deletes the user's account.

---

### Blog Routes

- **GET** `/blogs`

  - Retrieves a list of all blogs.

- **GET** `/blogs/:id`

  - Retrieves a blog by `id`.

- **GET** `/blogs/user/:user_id`

  - Retrieves all blogs created by a specific user.

- **POST** `/blogs`

  - Creates a new blog post.

- **PATCH** `/blogs/:id`

  - Updates a blog post by `id`.

- **PUT** `/blogs/:id`

  - Same as `PATCH`, for updating the entire blog data.

- **DELETE** `/blogs/:id`

  - Deletes a blog post by `id`.

- **PATCH** `/blogs/:id/toggle_publish`
  - Toggles the `is_publish` status of a blog post.

---

## Additional Notes

1. **Rails Environment:** The default environment is `development`. If you want to run commands in a different environment, set the `RAILS_ENV` environment variable.

   ```bash
   docker-compose exec web rails db:migrate RAILS_ENV=production
   ```

2. **Logs:** To view the Rails logs, use:

   ```bash
   docker-compose logs -f web
   ```

3. **Database Debugging:** To connect to the PostgreSQL database from the container:
   ```bash
   docker-compose exec db psql -U postgres
   ```
