# USERS Endpoints Documentation 🌊

## Introduction

The "USERS" endpoints allow you to manage user-related operations within the AIWAVE application. These endpoints handle user deletion, retrieval, attribute retrieval, and user updates.

---

### Get User 🧑‍🔬

- **HTTP Method**: GET
- **URL Pattern**: `/users/<user_uid>`

**Description**: Get a user from the database.

**Request**:
- This endpoint requires authentication.

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.
    - `data` (object): User data.

- Error (🔴 Status Code: 404 Not Found or 500 Internal Server Error):
    - `error` (string): Error details.

**Example Request**:
```bash
GET /users/x    # This is a admin user for testing
```

**Example Response** (Success):
```json
{
    "message": "Successfully retrieved user.",
    "status": 200,
    "data": {
        "uid": "x",
        "username": "admin",
        "age": 22,
        "email": "admin@admin.com",
        "image_url": "https://images.pexels.com/photos/9668535/pexels-photo-9668535.jpeg?auto=compress&cs=tinysrgb&w=1600",
        "media": "...", // This is a list of media objects you can find in the `/users/<user_uid>/media` endpoints
        "data": null,
        "role": "admin", // Rules: *admin, user
        "created_at": "Sat, 30 Sep 2023 12:58:22 GMT",
        "updated_at": null,
    },
}
```

---

### Get User Attribute 🔍

- **HTTP Method**: GET
- **URL Pattern**: `/users/<user_uid>/<attribute>`

**Description**: Get a specific attribute of a user from the database.

**Request**:
- This endpoint requires authentication.

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.
    - `data` (object): User attribute value.

- Error (🔴 Status Code: 404 Not Found or 500 Internal Server Error):
    - `error` (string): Error details.

**Example Request**:

```http
GET /users/user123/username
```

**Example Response** (Success):
```json
{
  "message": "Successfully retrieved user attribute.",
  "data": "john_doe"
}
```

---

### Get User Media 📷

- **HTTP Method**: GET
- **URL Pattern**: `/users/<user_uid>/media`

**Description**: Get a user's media from the database.

**Request**:
- This endpoint not requires authentication.

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.
    - `data` (object): User media.

- Error (🔴 Status Code: 404 Not Found or 500 Internal Server Error):


**Example Request**:

```http
GET /users/user123/media
```

**Example Response** (Success):
```json
{
  "message": "Successfully retrieved user media.",
  "data": [
    {
        "uid": "media_1",
        "user_uid": "user123",
        "file_name": "image.jpg",
        "file_type": "image/jpeg",
        "file_path": "storage/media/user123/image.jpg",
        "thumbnail_url": "https://example.com/    thumbnail.jpg",
        "data": null,
        "ai_processes": [...],
        "created_at": "Sat, 30 Sep 2023 12:58:22 GMT",
        "updated_at": null,
    }
    // More media objects
    ...
  ]
}
```

---

### Get User Media By UID 📷

- **HTTP Method**: GET
- **URL Pattern**: `/users/<user_uid>/media/<media_uid>`

**Description**: Get a user's media by UID from the database.

**Request**:
- This endpoint not requires authentication.

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.
    - `data` (object): User media.

- Error (🔴 Status Code: 404 Not Found or 500 Internal Server Error):

**Example Request**:

```http
GET /users/user123/media/media_1
```

**Example Response** (Success):
```json
{
  "message": "Successfully retrieved user media.",
  "data": {
    "uid": "media_1",
    "user_uid": "user123",
    "file_name": "image.jpg",
    "file_type": "image/jpeg",
    "file_path": "storage/media/user123/image.jpg",
    "thumbnail_url": "https://example.com/    thumbnail.jpg",
    "data": null,
    "ai_processes": [...],
    "created_at": "Sat, 30 Sep 2023 12:58:22 GMT",
    "updated_at": null,
  }
}
```

---

### DELETE User Media By UID 📷

- **HTTP Method**: DELETE
- **URL Pattern**: `/users/<user_uid>/media/<media_uid>/delete`

**Description**: Delete a user's media by UID from the database.

**Request**:
- This endpoint not requires authentication.

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.

- Error (🔴 Status Code: 404 Not Found or 500 Internal Server Error):

**Example Request**:

```http
DELETE /users/user123/media/media_1/delete
```

**Example Response** (Success):
```json
{
  "message": "Successfully deleted user media."
}
```

---

### Get porcesses by media UID 📷

- **HTTP Method**: GET
- **URL Pattern**: `/users/<user_uid>/media/<media_uid>/ai_processes`

**Description**: Get a user's media by UID from the database.

**Request**:
- This endpoint not requires authentication.    

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.
    - `data` (object): User media.

- Error (🔴 Status Code: 404 Not Found or 500 Internal Server Error):

**Example Request**:

```http
GET /users/user123/media/media_1/ai_processes
```

**Example Response** (Success):
```json
{
  "message": "Successfully retrieved user media.",
  "data": [
    {
        "uid": "process_1",
        "media_uid": "media_1",
        "model_name": "model_1",
        "task": "classification",
        "model_key": "ml",
        "data": null,
        "created_at": "Sun, 01 Sep 2004 12:09:12 GMT",
        "updated_at": null,
    }
    // More processes objects
    ...
  ]
}
```

---

### Get porcesses by process UID 📷

- **HTTP Method**: GET
- **URL Pattern**: `/users/<user_uid>/media/<media_uid>/ai_processes/<process_uid>`

**Description**: Get a user's media by UID from the database.

**Request**:
- This endpoint not requires authentication.

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.
    - `data` (object): User media.

- Error (🔴 Status Code: 404 Not Found or 500 Internal Server Error):

**Example Request**:

```http
GET /users/user123/media/media_1/ai_processes/process_1
```

**Example Response** (Success):
```json
{
  "message": "Successfully retrieved user media.",
  "data": {
    "uid": "process_1",
    "media_uid": "media_1",
    "model_name": "model_1",
    "task": "classification",
    "model_key": "ml",
    "data": null,
    "created_at": "Sun, 01 Sep 2004 12:09:12 GMT",
    "updated_at": null,
  }
}
```

---

### DELETE porcesses by process UID 📷

- **HTTP Method**: DELETE
- **URL Pattern**: `/users/<user_uid>/media/<media_uid>/ai_processes/<process_uid>/delete`

**Description**: Get a user's media by UID from the database.

**Request**:
- This endpoint not requires authentication.

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.

- Error (🔴 Status Code: 404 Not Found or 500 Internal Server Error):

**Example Request**:

```http
DELETE /users/user123/media/media_1/ai_processes/process_1/delete
```

**Example Response** (Success):
```json
{
  "message": "Successfully deleted user media."
}
```

---

### Update User 🔄

- **HTTP Method**: PUT
- **URL Pattern**: `/users/<user_uid>/update`

**Description**: Update a user in the database.

**Request**:

- This endpoint requires authentication.
- The request body should contain updated user data.

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.

- Error (🔴 Status Code: 404 Not Found or 500 Internal Server Error):
    - `error` (string): Error details.

**Example Request**:

```http
PUT /users/x/update
```
<code class='json-code'>{
  "username": "new_username",
  "age": 22,
  "image_url": "https://example.com/avatar.jpg"
}```


**Example Response** (Success):
```json

{
  "message": "User with uid `x` updated successfully."
}
```
---

### Delete User 🚫

- **HTTP Method**: DELETE
- **URL Pattern**: `/users/<user_uid>/delete`

**Description**: Delete a user from the database.

**Request**:

- This endpoint requires authentication.

**Response**:

- Success (🟢 Status Code: 200 OK):
    - `message` (string): Success message.

- Error (🔴 Status Code: 403 Forbidden, 404 Not Found, or 500 Internal Server Error):
    - `error` (string): Error details.

**Example Request**:

```http
DELETE /users/user_9/delete # This is a user for testing you can't delete `admin` users
```

**Example Response** (Success):
```json
{
  "message": "User with uid `user_9` deleted successfully."
}```
