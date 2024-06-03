# STORAGE Endpoints Documentation 📂

## Introduction

The **"STORAGE"** endpoints are responsible for managing file uploads, serving files, and retrieving folder contents. These endpoints enable efficient handling of file storage and access within `AIWAVE`.

---

### AI Upload File 🤖

- **HTTP Method**: POST
- **URL Pattern**: `/ai/upload`

**Description**: Upload files with AI processing.

**Request**:

- This endpoint requires authentication as an admin user.
    - <u>The request should contain a valid `user_uid` in the `x-user-id` header.</u>


- The request should contain a list of files.

**Response**:

- <span style="color:green;">Success</span> (Status Code: 200 OK):
    - `message` (string): Success message.
    - `files` (list): Upload report for each file.

- <span style="color:gold;">Partial Success</span> (Status Code: 206 Partial Content):
    - `message` (string): Partial success message.
    - `files` (list): Upload report for each file.

- <span style="color:red;">Error</span> (Status Code: 400 Bad Request or 500 Internal Server Error):
    - `error` (string): Error details.
    - `files` (list, optional): Upload report for each file.

**Example Request**:

- `files` (list): List of files to upload (`form-data`): 
      - Each file should be a `file` object.


**Example Response** (Success):
```json
{
  "message": "Files uploaded successfully.",
  "files": [
    {
        "file_name": "uploaded successfully",
        "status": "success",
        "media": {
            "uid": "xxxx-xxxx-xxxx-xxxx",
            "ai_process": "...",
            "user_uid": "x", // This is a admin user for testing
            "file_name": "file1.txt",
            "file_type": ".txt",
            "file_path": "\\storage\\backend\\x\\documents/xx-xx.txt",
            "file_url": "https://example.com/storage/file1.txt",
            "data": null,
            "created_at": "2023-01-09 12:12:04",
            "updated_at": "2023-12-12 09:01:01",
        },
    }
  ]
}
```

**Example Response** (Partial Success):
```json
{
  "message": "Some files uploaded successfully.",
  "files": [
    // Success files...
    {
        "file_name": "uploaded successfully",
        "status": "success",
        "media": {
            "id": "5f9b-3b3b-3b3b-3b3b",
            "user_uid": "x", // This is a admin user for testing
            "file_name": "file1.txt",
            "file_type": "text/plain",
            "file_path": "storage/file1.txt",
            "file_url": "https://example.com/storage/file1.txt",
            "data": {
                "text": "This is a text file."
            },
            "created_at": "2023-01-09 12:12:04",
            "updated_at": "2023-12-12 09:01:01",
        },
    },
    // Error files...
    {
        "file_name": "unsupported file format: ..",
        "status": "error",
    }
    // More files...
  ]
}
```

**Example Response** (Error):
```json
{
  "message": "No file uploaded successfully.",
  "files": [
    {
        "file_name": "unsupported file format: ..",
        "status": "error",
    }
    // More files...
  ]
}
```

---

### Get Folder Contents 📁

- **HTTP Method**: GET
- **URL Pattern**: `/folders/` (List root folder contents)
- **URL Pattern**: `/folders/<path:folder_path>` (List contents of a specified folder)

**Description**: Retrieve the contents (folders and files) of the specified folder path or serve a file if it exists.

**Request**:
- No authentication required.

**Response**:

- <span style="color:green;">Success</span> (Status Code: 200 OK):
    - `message` (string): Success message.
    - `folder_path` (string): Path to the folder.
    - `contents` (list): List of folders and files.

- <span style="color:gold;">File Serve</span> (Status Code: 200 OK):
    - The file itself is served.

- <span style="color:red;">Error</span> (Status Code: 400 Bad Request or 500 Internal Server Error):
    - `error` (string): Error details.

**Example Request**:
  - `front-end` :

    ```bash
    GET /folders/<folder_path>
    ```
  
  - `back-end`:

    ```bash
    GET /folders/storage/backend/<user_uid>/...
    ```

**Example Response** (Success):
```json
{
  "message": "Successfully served the folder contents.",
  "status": 200,
  "folder_path": "./",
  "contents": [
      {
          "folder": "test1"
      },
      {
          "file": "test2"
      }
  ],
}

```

---

### Upload File 📄

- **HTTP Method**: POST
- **URL Pattern**: `/upload`

**Description**: Upload files to a specified folder.

**Request**:
- The request should contain a list of `files`` to upload.
- The request may include the `files_dir` parameter to specify the destination folder.

**Response**:

- <span style="color:green;">Success</span> (Status Code: 200 OK):
    - `message` (string): Success message.
    - `files` (list): Upload report for each file.

- <span style="color:gold;">Partial Success</span> (Status Code: 206 Partial Content):
    - `message` (string): Partial success message.
    - `files` (list): Upload report for each file.

- <span style="color:red;">Error</span> (Status Code: 400 Bad Request or 500 Internal Server Error):
    - `error` (string): Error details.
    - `files` (list, optional): Upload report for each file.

**Example Request**:

- Upload files to a specific folder.

**Example Response** (Success):
```json

{
  "message": "Files uploaded successfully.",
  "files": [
    {
        "file_name": "uploaded successfully",
        "status": "success",
        "file_name": "file1.txt",
        "file_type": "txt",
        "file_url": "https://example.com/uploads/file1.txt",
    },
    // More files...
  ]
}
```

**Example Response** (Partial Success):
```json

{
  "message": "Some files uploaded successfully.",
  "files": [
    {
      "filename": "file1.txt",
      "status": "success",
      "file_url": "https://example.com/uploads/file1.txt"
    },
    {
      "filename": "file2.jpg", // The server support the `.jpg` format this just an example
      "status": "error",
      "error": "unsupported file format: .jpg"
    }
    // More files...
  ]
}
```

**Example Response** (Error):
```json

{
  "message": "No file uploaded successfully.",
  "files": [
    {
      "filename": "file1.txt", // The server support the `.txt` format this just an example
      "status": "error",
      "error": "unsupported file format: .txt"
    },
    // More files...
  ]
}
```
