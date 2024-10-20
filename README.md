# AI Project Documentation

## Overview

This project is an AI application that utilizes Flask for the backend, Flutter for the frontend, and employs Docker to manage services such as Redis and PostgreSQL. This documentation provides instructions on how to set up and launch the project using Docker Compose.

## Project Structure

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Basic knowledge of Flask and Flutter

## Setup Instructions

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone <repository-url>
cd your-project
```

then enter the project and run this command
```bash
docker-compose up --build
```

web: The Flask backend service.
db: The PostgreSQL database service.
redis: The Redis caching service.

frontend: flutter
