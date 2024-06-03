# WORDWAVE Endpoints Documentation 🌊

## Introduction

The "WORDWAVE" endpoints allow you to perform word-wave processing operations within the AIWAVE application. These endpoints handle running word-wave tasks and retrieving their status.


WORDWAVE's performance varies widely depending on the language. The figure below shows a WER (Word Error Rate) breakdown by languages of the Fleurs dataset using the large-v2 model (The smaller the numbers, the better the performance). Additional WER scores corresponding to the other models and datasets can be found in Appendix D.1, D.2, and D.4. Meanwhile, more BLEU (Bilingual Evaluation Understudy) scores can be found in Appendix D.3. Both are found in the [paper](https://arxiv.org/abs/2212.04356).

<img src="./assets/language-breakdown.svg" alt="Language Breakdown" width="100%"/>

---

### Run Word-Wave 🏃‍♂️

- **HTTP Method**: POST
- **URL Pattern**: `/run`

**Description**: Run the word-wave process.

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
POST /run
```
```json
{
  "media_uid": "xxx-xxx-xxx-xxx", // Required 
  "language_code": "en",         // Optional buy default is "auto"
  "task": "default",             // // Optional. Default: `default``. Available tasks: Available tasks: (transcribe, translate, default).
}
```

**Example Response** (Success):

```json
{
  "message": "Word Wave is running",
  "status": {
    "uid"          : "xxx-xxx-xxx-xxx",
    "model_name"   : "word_wave",
    "state"        : "pending",
    "state_message": "Initialized the WordWave process.",
    "state_details": null, // When the process is completed, this field will contain json like `state_details` Example.
    "progress"     : {
        "[1] Initializing the WordWave process"                  : "pending",
        "[2] Detecting the language of the audio"                : "pending",
        "[3] Transcribing the audio"                             : "pending", 
        "[4] Concatenating the SRT file with the original video" : "pending",
        "[5] WordWave process completed"                         : "pending",
    },
    "timestamp": "2023-01-09 12:12:04",
  }
}
```

---

### Get Word-Wave Status 📊

- **HTTP Method**: GET
- **URL Pattern**: `/status/<status_uid>`

**Description**: Retrieve the status of a word-wave process.

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
GET /status/xxxx-xxxx-xxxx-xxxx
```

**Example Response** (Success):

```json
{
  "message": "Status is retrieved",
  "status": {
    "uid"          : "xxx-xxx-xxx-xxx",
    "model_name"   : "word_wave",
    "state"        : "pending",
    "state_message": "Initialized the WordWave process.",
    "state_details": null, // When the process is completed, this field will contain json like `state_details` Example.
    "progress"     : {
        "[1] Initializing the WordWave process"                  : "pending",
        "[2] Detecting the language of the audio"                : "pending",
        "[3] Transcribing the audio"                             : "pending", 
        "[4] Concatenating the SRT file with the original video" : "pending",
        "[5] WordWave process completed"                         : "pending",
    },
    "timestamp": "2023-01-09 12:12:04",
  }
}

```

**Example Response** (state_details):

```json

```

---

### Get Word-Wave Media 📊

- **HTTP Method**: GET
- **URL Pattern**: `/media/`

**Description**: Retrieve the media of word-wave model.

**Request**:

- This endpoint requires authentication.

**Response**:

- Success (🟢 Green Color):
    - `message` (string): Success message.
    - `status` (object): word-wave status.

- Error (🔴 Red Color):
    - `error` (string): Error details.

**Example Request**:

```bash
GET /media
```

**Example Response** (Success):

```json
{
    "message": "Media is retrieved",
    "status": 200,
    "media_list": [
        {
            // The media map
        }
    ],
}
```

---

### Get Word-Wave media details by uid 📊

- **HTTP Method**: GET
- **URL Pattern**: `/media/<string:media_uid>`

**Description**: Retrieve the details of a word-wave process.

**Request**:

- This endpoint requires authentication.

**Response**:

- Success (🟢 Green Color):
    - `message` (string): Success message.
    - `status` (object): word-wave status.

- Error (🔴 Red Color):
    - `error` (string): Error details.

**Example Request**:

```bash
GET /media/xxxx-xxxx-xxxx-xxxx
```

**Example Response** (Success):

```json
{
    "message": "media is retrieved",
    "status": 200,
    "media": {
        "uid": "xxxx-xxxx-xxxx-xxxx", 
        "media_uid": "xxxx-xxxx-xxxx-xxxx", // The media uid
        "model_key": "xx",
        "model_name": "xxx_xxx",
        "created_at": "2023-01-09 12:12:04",
        "updated_at": null,
        "data": {
            // The same as the `state_details` field
        },
    },
}
```

---

### Get Word-Wave media content by uid 📊

- **HTTP Method**: GET
- **URL Pattern**: `/media/<string:media_uid>/<string:process_uid>/content`

**Description**: Retrieve the content of a word-wave process.

**Request**:

- This endpoint requires authentication.

**Response**:

- Success (🟢 Green Color):
    - `message` (string): Success message.
    - `status` (object): word-wave status.

- Error (🔴 Red Color):
    - `error` (string): Error details.

**Example Request**:

```bash
GET /media/xxxx-xxxx-xxxx-xxxx/xxxx-xxxx-xxxx-xxxx/content
```

**Example Response** (Success):

```json
{
    "message": "media content is retrieved",
    "status": 200,
    "process": {
        "uid": "xxxx-xxxx-xxxx-xxxx", 
        "media_uid": "xxxx-xxxx-xxxx-xxxx", // The media uid
        "model_key": "xx",
        "model_name": "xxx_xxx",
        "task": "default",
        "created_at": "2023-01-09 12:12:04",
        "updated_at": null,
        "data": {
            // The same as the `state_details` field
        },
    },
}
```
