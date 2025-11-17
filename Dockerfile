FROM linuxserver/ffmpeg:latest

# Install Python and system dependencies
RUN apt-get update && apt-get install -y \
    # Add common utilities
    pciutils \
    wget \
    nano \
    curl \
    # Python dependencies
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN python3 -m venv /app/venv && \
    /app/venv/bin/pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/ ./src/
COPY main.py .
COPY .env.example .env

# Copy Docker scripts
COPY docker/ ./docker/

# Create directories
RUN mkdir -p /tmp/m3u-proxy-streams

# Make scripts executable
RUN chmod +x /app/docker/entrypoint.sh /app/docker/check-hwaccel.sh /app/docker/verify-hwaccel.sh

# Environment variables
ENV PYTHONPATH=/app

# Override the default entrypoint and run the application
ENTRYPOINT ["/app/docker/entrypoint.sh"]
