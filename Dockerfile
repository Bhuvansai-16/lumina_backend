# ===============================
# 1️⃣ Base image
# ===============================
FROM python:3.11-slim AS base

# Prevents Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory inside container
WORKDIR /app

# ===============================
# 2️⃣ Install system dependencies
# ===============================
# (optional but ensures compatibility with common packages like Pillow, numpy, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ===============================
# 3️⃣ Copy and install dependencies
# ===============================
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ===============================
# 4️⃣ Copy application source
# ===============================
COPY . .

# ===============================
# 5️⃣ Expose Cloud Run port
# ===============================
EXPOSE 8080

# ===============================
# 6️⃣ Run FastAPI with Uvicorn
# ===============================
# Replace "main:app" with your actual entrypoint if your file is named differently.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
