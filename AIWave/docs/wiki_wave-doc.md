# WIKIWAVE Endpoints Documentation 🌊

## Introduction

WikiWave Search is an AI-powered tool that leverages large language models (LLM) to search Wikipedia for information. Users can input queries, and the AI will provide information from Wikipedia articles, making it a convenient and efficient way to access knowledge from one of the largest online encyclopedias.

[Wikipedia](https://www.wikipedia.org/) is a multilingual free online encyclopedia written and maintained by a community of volunteers, known as Wikipedians, through open collaboration and using a wiki-based editing system called MediaWiki. Wikipedia is the largest and most-read reference work in history.

---

### Run Wiki-Wave 🏃‍♂️

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
   "conversation_uid": "xxxx-xxxx-xxxx-xxxx", // Optional
}
```

**Example Response** (Success):

```json
{
    "message": "Wiki Wave run successfully",
    "output": {
        "answer": "The black hole is a hypothetical type of astronomical object that has a gravitational field so strong that nothing, not even light, can escape from it. The theory of general relativity predicts that a sufficiently compact mass can deform spacetime to form a black hole. The boundary of this region, known as the event horizon, is beyond which nothing, not even light, can escape. The only way for matter and light to escape the gravitational pull of a black hole is if they are moving faster than the speed of light, which is impossible. As a result, black holes are invisible to the outside world, and the only way to detect them is through their gravitational effects on other objects.\nBlack holes are formed when a very massive star collapses under its own gravity. When a star dies, it loses mass through a variety of processes, such as winds and radiation. If a star is massive enough, it will eventually collapse to a point where its gravity becomes so strong that no force, not even the strong nuclear force, can prevent it from collapsing further. This point is known as the Schwarzschild radius, and it is the radius of the event horizon of a black hole.\nBlack holes are one of the most extreme objects in the universe. They are so dense that their gravity is stronger than the electromagnetic force, which means that even light cannot escape from them. This makes black holes invisible to the outside world, and the only way to detect them is through their gravitational effects on other objects.\nThere are two types of black holes: stellar black holes and supermassive black holes. Stellar black holes are formed when a very massive star collapses under its own gravity. Supermassive black holes are much larger than stellar black holes, and they are found at the center of most galaxies.",
        "uid": "wc-xxxx-xxxx-xxxx-xxxx"
    },
    "status": 200
}

```

---

### Get Wiki Conversations 📊

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
