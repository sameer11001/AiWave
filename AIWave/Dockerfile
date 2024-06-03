# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Update pip to the latest version, and install needed packages
RUN pip install --no-cache-dir --upgrade pip \
    && apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install torch
# RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 # CUDA GPU
RUN pip install torch torchvision torchaudio

# Set the working directory inside the container
WORKDIR /waveenv

# Copy the requirements file into the container at /waveenv
COPY requirements.txt /waveenv/
# Install any needed packages specified in requirements files
RUN pip install --no-cache-dir -r requirements.txt

# Copy the requirements.dev file into the container at /waveenv
COPY requirements-dev.txt /waveenv/
# Install any needed packages specified in requirements files [dev]
RUN pip install --no-cache-dir -r requirements-dev.txt

# Copy the folders
COPY . /waveenv

# Expose the port that the Flask app will run on
EXPOSE 7651

# Define the command to run your application
CMD ["python", "app.py", "-p"]