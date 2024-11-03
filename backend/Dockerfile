# Use the official Python 3.11 slim image as the base image
FROM python:3.11-slim

# Install Poetry
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Set the working directory
WORKDIR /app

# Copy the pyproject.toml and poetry.lock files
COPY pyproject.toml poetry.lock ./

# Install dependencies
RUN poetry install

# Copy the rest of the application code
COPY . .

# Set the entry point for the container
CMD ["poetry", "run", "python", "your_main_script.py"]