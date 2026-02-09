# Stage 1: Get FFmpeg from a trusted source
FROM mwader/static-ffmpeg:8.0 AS ffmpeg

# Stage 2: Use the official n8n v2 stable image
FROM n8nio/n8n:stable

USER root

# Copy the ffmpeg binaries from the first stage into n8n
COPY --from=ffmpeg /ffmpeg /usr/local/bin/
COPY --from=ffmpeg /ffprobe /usr/local/bin/

# Set permissions so the 'node' user can run them
RUN chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe

# Download and install yt-dlp as a standalone binary
RUN wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp && \
    chmod +x /usr/local/bin/yt-dlp

# Install Python 3 - using musl build for Alpine compatibility
RUN wget https://github.com/indygreg/python-build-standalone/releases/download/20231002/cpython-3.11.6+20231002-x86_64_v3-unknown-linux-musl-install_only.tar.gz && \
    tar -xzf cpython-3.11.6+20231002-x86_64_v3-unknown-linux-musl-install_only.tar.gz -C /usr/local --strip-components=1 && \
    rm cpython-3.11.6+20231002-x86_64_v3-unknown-linux-musl-install_only.tar.gz

USER node