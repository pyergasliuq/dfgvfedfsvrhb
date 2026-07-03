# Dockerfile for Pweper Bot — runtime only (no build needed).
# Бинарник уже скомпилирован с AVX2 (GOAMD64=v3).
#
# just copy this Dockerfile + pweper-bot + bin/astcenc + assets/
# to the host and run: docker build -t pweper-bot .

FROM debian:bookworm-slim

# Install runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Working directory
WORKDIR /app

# Copy pre-compiled binary
COPY pweper-bot /app/pweper-bot
RUN chmod +x /app/pweper-bot

# Copy astcenc (AVX2 version)
COPY bin/astcenc /usr/local/bin/astcenc
RUN chmod +x /usr/local/bin/astcenc

# Copy assets
COPY assets/ /app/assets/

# Create data/logs/work dirs
RUN mkdir -p /app/data /app/logs /app/work

# Environment defaults (MUST be set via bothost panel or -e flags)
ENV TOKEN="" \
    API_ID="" \
    API_HASH="" \
    ADMIN_IDS="" \
    ONLYSQ_API_KEY="" \
    DB_PATH=/app/data/users.db \
    WORK_DIR=/app/work \
    ASSETS_DIR=/app/assets \
    LOG_FILE=/app/logs/pweper.log \
    LOG_LEVEL=info \
    ENABLE_MTPROTO=0

# Volumes for persistent data
VOLUME ["/app/data", "/app/logs", "/app/work"]

# Run bot
ENTRYPOINT ["/app/pweper-bot"]
