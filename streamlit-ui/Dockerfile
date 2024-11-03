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
COPY streamlit_ui /app/streamlit_ui

ENV PYTHONPATH=/app

EXPOSE 3001
# Set the entry point for the container
CMD ["poetry", "run", "streamlit", "run", "streamlit_ui/main.py", "--server.port=3001", "--server.address=0.0.0.0"]