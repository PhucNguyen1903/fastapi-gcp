# Stage 1: Builder base - install Poetry and dependencies
FROM python:3.9-slim-bookworm AS builder-base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.8.3 \
    POETRY_VIRTUALENVS_CREATE=true \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH" \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME='/usr/local'

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install Poetry and create virtual environment
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    python -m venv /opt/venv

# Add Poetry and venv to PATH
ENV PATH="$POETRY_HOME/bin:/opt/venv/bin:$PATH"

WORKDIR /app

# Activate virtual environment and configure Poetry
RUN . /opt/venv/bin/activate && \
    poetry config virtualenvs.in-project false && \
    poetry config virtualenvs.path /opt/venv

# Copy pyproject.toml first to cache dependencies layer
COPY pyproject.toml ./

# Create poetry.lock if it doesn't exist and install dependencies
RUN if [ ! -f poetry.lock ]; then \
        echo "poetry.lock not found, creating new lock file..." && \
        poetry lock; \
    fi

# Install dependencies in the virtual environment
RUN . /opt/venv/bin/activate && \
    poetry install --no-dev --no-root --no-interaction --no-ansi && \
    # Verify installation
    python -c "import sys; print(sys.prefix)"

# Copy app source code
COPY src/ ./src/

# Stage 2: Final Distroless Runtime Image
FROM gcr.io/distroless/python3-debian11:debug AS runtime

# Set working directory
WORKDIR /app

# Copy app and venv from builder-prod
COPY --chown=65532:65532 --from=builder-base /app /app
COPY --chown=65532:65532 --from=builder-base /opt/venv /opt/venv

# Set environment variables
ENV PYTHONPATH="/app:/opt/venv/lib/python3.9/site-packages:${PYTHONPATH:-}" \
    VIRTUAL_ENV="/opt/venv" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Use non-root user (nobody)
USER 65532:65532

# Expose the port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD ["python3", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/')"]

# Run uvicorn using Python module
ENTRYPOINT ["python3", "-m", "uvicorn"]
CMD ["src.main:app", "--host", "0.0.0.0", "--port", "8000"]
