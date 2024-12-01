# Base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV MODEL_PATH=/app/ckpt/u2net.pth

# Install Python dependencies
COPY webapp/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create necessary directories and set permissions
RUN mkdir -p /app/webapp/images-input \
    /app/webapp/images-output \
    /app/ckpt \
    && chmod -R 777 /app/webapp/images-input \
    && chmod -R 777 /app/webapp/images-output

# Download the model
RUN pip install gdown && \
    gdown --id 1ao1ovG1Qtx4b7EoskHXmi2E9rp5CHLcZ -O /app/ckpt/u2net.pth

# Copy application code
COPY webapp /app/webapp

WORKDIR /app/webapp

# Expose the port for the application
EXPOSE 8005

# Default command to run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8005"]