# RESEARCHERWAVE Endpoints Documentation 🌊

## Introduction

Researcher Wave is an advanced artificial intelligence system meticulously crafted for the purpose of generating scientific research that draws from reputable sources, such as 'arXiv.' Leveraging the power of large language models (LLM), this AI is primed to dissect and synthesize existing research, ultimately producing fresh scientific revelations and scholarly papers. The overarching objective is to streamline and accelerate the research endeavor.

[arXiv](https://arxiv.org/) is an open-access archive for 2 million scholarly articles in the fields of physics, mathematics, computer science, quantitative biology, quantitative finance, statistics, electrical engineering and systems science, and economics.

---

### Run Researcher-Wave 🏃‍♂️

- **HTTP Method**: POST
- **URL Pattern**: `/chatbot`

**Description**: Run the chatbot and get the response.

**Request**:

- This endpoint requires authentication.

**Response**:

- Success (🟢  Status Code: 200 OK):
    - `message` (string): Success message.
    - `status` (object): Word-wave status.

- Error (🔴 Status Code: 400 Bad Request or 500 Internal Server Error):
    - `error` (string): Error details.

**Example Request**:

```bash
POST /chatbot
```
```json
{
  "prompt": "Write a paragraph about the black hole. with full details",
  "source": "arxiv" //  // Optional. Default: `arxiv``. Available source: (source, wiki).
}
```

**Example Response** (Success):

```json
{
    "message": "Researcher Wave run successfully",
    "status": 200,
    "output": {
        "answer": "Black holes are regions of spacetime with such intense gravitational fields that no matter or radiation can escape them. The theory of general relativity predicts that a sufficiently compact mass will deform spacetime to form a black hole. The boundary of the region from which no escape is possible is called the event horizon. Although the event horizon has an infinite surface gravity, the gravitational pull felt by an observer outside the event horizon is no stronger than that of a non-rotating star of the same mass. As light cannot escape the event horizon, no information from within can reach an outside observer. This makes black holes one of the most mysterious objects in the universe."
    }
}

```

---

### Get Researcher Conversations 📊

- **HTTP Method**: GET
- **URL Pattern**: `/conversations`

**Description**: Retrieve all conversations.

**Request**:

- This endpoint requires authentication.

**Response**:

- Success (🟢 Green Color):
    - `message` (string): Success message.
    - `status` (object): Word-wave status.

- Error (🔴 Red Color):
    - `error` (string): Error details.

**Example Request**:

```bash
GET /conversations
```

**Example Response** (Success):

```json
{
    "message": "The conversations were retrieved successfully.",
    "data": ["xxxx-xxxx-xxxx-xxxx", "xxxx-xxxx-xxxx-xxxx"]
}
```

#### Get a Single Conversation

You can retrieve detailed information about a specific conversation by sending a GET request to `/conversations/<conversation_uid>`.

##### Request

- **Method:** GET
- **Endpoint:** `/conversations/<conversation_uid>`

- `conversation_uid` (string): The unique identifier of the conversation you want to retrieve.

#### Response

- **Success Response** (HTTP Status 200)

    If the request is successful and the conversation exists, you will receive a JSON response with the following structure:

    - `message` (string): A success message.
    - `data` (dictionary): Information about the conversation.

    Example Success Response:

    ```json
    {
        "message": "The conversation was retrieved successfully.",
        "data": {
            // Conversation details
        }
    }
    ```

- **Error Response** (HTTP Status 400)

    If the request contains invalid data or encounters an error, you will receive an error response with details of the issue. The response will include an error message and an error code.

    Example Error Response:

    ```json
    {
        "error": "Conversation not found.",
        "code": 404
    }
    ```

# Get the resarcher document 📊

- **HTTP Method**: GET
- **URL Pattern**: `/docs`

**Description**: Retrieve all documents.

**Request**:

- This endpoint requires authentication.

**Response**:

- Success (🟢 Green Color):
    - `message` (string): Success message.
    - `status` (object): Word-wave status.

- Error (🔴 Red Color):
    - `error` (string): Error details.

**Example Request**:
    
    ```bash
    GET /docs
    ```

**Example Response** (Success):
    
    ```json
    {
        "message": "The documents were retrieved successfully.",
        "docs": [
            {
                "file_name": "black_hole_introduction",
                "file_url": "https://researcherwave.com/docs/black_hole_introduction",
                "content": "Black holes are regions of spacetime with such intense gravitational fields that no matter or radiation can escape them. The theory of general relativity predicts that a sufficiently compact mass will deform spacetime to form a black hole. The boundary of the region from which no escape is possible is called the event horizon. Although the event horizon has an infinite surface gravity, the gravitational pull felt by an observer outside the event horizon is no stronger than that of a non-rotating star of the same mass. As light cannot escape the event horizon, no information from within can reach an outside observer. This makes black holes one of the most mysterious objects in the universe."
            }
            # Another document
            ...
        ]
    }
    ```

