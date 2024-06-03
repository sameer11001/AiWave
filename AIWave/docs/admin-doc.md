# ADMIN Endpoint Documentation 🛡️

## Introduction

The "ADMIN" endpoint is designed for administrative purposes.

---

### Get All Users 🧑‍💻

- **HTTP Method**: GET
- **URL Pattern**: `/users`

**Description**: Retrieve a list of all users from the database.

**Request**:
- This endpoint requires authentication as an admin user.

  - <u>The request should contain a valid `user_uid` in the `x-user-id` header.</u>

**Response**:

- <span style="color:green;">Success</span> (Status Code: 200 OK):

    - `message` (string): Success message.
    - `data` (list): A list of user objects in dictionary format.

- <span style="color:gold;">No Users Found</span>  (Status Code: 204 No Content):

    - `message` (string): Informational message.
    - `data` (list): An empty list indicating no users found.

- <span style="color:red;">Error</span>  (Status Code: 400 Bad Request, 403 Forbidden, or 500 Internal Server Error):

    - `message` (string): Error message.
    - `error` (string): Error details.
    - `code` (int): Error code.

**Example Request**:
```http
GET /users
```

**Example Response** (Success):
```json
{
  "message": "Successfully retrieved all users.",
  "data": [
    {
      "id": 1,
      "username": "john_doe",
      "email": "john@example.com"
      // Other user data...
    },
    {
      "id": 2,
      "username": "jane_smith",
      "email": "jane@example.com"
      // Other user data...
    }
    // More users...
  ]
}
```

**Example Response** (No Users Found):
```json
{
  "message": "No users found.",
  "data": []
}
```

**Notes**:
- This endpoint requires authentication as an admin user. Ensure that proper authentication mechanisms are in place.
- If no users are found, a custom response with a status code of 204 is returned to indicate the absence of data.
- Error handling is crucial to provide informative error messages and status codes for different scenarios.
