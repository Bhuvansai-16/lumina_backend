# Use a slim Python image
FROM python:3.11-slim

# Environment
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    git \
    curl \
    libjpeg-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt /app/requirements.txt

RUN python -m pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy application code
COPY . /app

# Ensure permissions (optional)
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser || true
RUN chown -R appuser:appgroup /app || true

USER appuser

EXPOSE ${PORT}

# Simple uvicorn command (no reload in production)
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
