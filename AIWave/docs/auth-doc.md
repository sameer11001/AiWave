# AUTH Endpoints Documentation 🚀

## Introduction

The "AUTH" endpoints handle user authentication and registration functionalities. These endpoints allow users to sign in and sign up for ``AIWAVE``.

---

### Sign In User ✅

- **HTTP Method**: POST
- **URL Pattern**: `/signin`

**Description**: Sign in an existing user.

**Request Body**:

- `email` (string): User's email address.
- `password` (string): User's password.

**Response**:

- <span style="color:green;">Success</span> (*Status Code*: <span style="color:green;">200 OK</span>):
  
    - `message` (string): Success message.
    - `user` (object): User data in a dictionary format.

- <span  style="color:red;">Error</span> (Status Code: <u>400</u> Bad Request or <u>500</u> Internal Server Error):

    - `message` (string): Error message.
    - `error` (string): Error details.
    - `code` (int): Error code.

**Example Request**:


```json
{
  "email": "user@example.com",
  "password": "secure_password"
}
```

**Example Response**:

```json
{
  "message": "Successfully signed in user.",
  "user": {
    "uid": "000 000 000",
    "email": "user@example.com",
    "username": "john_doe",
    "image_url": "https://example.com/avatar.jpg",
    "age": 25,
    "role": "user",
    "data": {
      "bio": "I'm a user.",
      "location": "Earth"
    },
    "created_at": "2023-01-09 12:12:04",
    "updated_at": "2023-12-12 09:01:01",
  }
}
```

---

### Sign Up User ✨

- **HTTP Method**: POST
- **URL Pattern**: `/signup`

**Description**: Register a new user.

**Request Body**:
- `email` (string): User's email address.
- `password` (string): User's password.
- `username` (string): User's username.
- `image_url` (string, `optional`): URL to user's profile image.
- `age` (int, `optional`): User's age.
- `data` (json, `optional`): Additional user data.

**Response**:
- <span style="color:green;">Success</span>  (Status Code: <span style="color:green;">200 OK</span>):
  - `message` (string): Success message.
  - `user` (object): User data in a dictionary format.

- <span style="color:red;">Error</span>  (Status Code: <u>400</u> Bad Request or <u>500</u> Internal Server Error):
  - `message` (string): Error message.
  - `error` (string): Error details.
  - `code` (int): Error code.

**Example Request**:
```json
{
  "email": "new_user@example.com",
  "password": "secure_password",
  "username": "new_user",
  "image_url": "https://example.com/avatar.jpg",
  "age": 22,
  "data": {
    "location": "Jordan"
  }
}
```

**Example Response**:
```json

{
  "message": "Successfully signed up user.",
  "user": {
    "uid": "111 111 111",
    "email": "new_user@example.com",
    "username": "new_user",
    "image_url": "https://example.com/avatar.jpg",
    "age": 22,
    "role": "user",
    "data": {
      "location": "Jordan"
    },
    "created_at": "2023-01-09 12:12:04",
    "updated_at": null,
  }
}
```
