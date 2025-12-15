# Perl Mojolicious E-Commerce Application
FROM perl:5.38-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    libpq-dev \
    postgresql-client \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy cpanfile and install dependencies
COPY cpanfile ./
RUN cpanm --notest --installdeps .

# Copy application files
COPY . .

# Create data directory for SQLite (local dev fallback)
RUN mkdir -p data

# Expose port (Render uses 10000, local uses 8080)
EXPOSE 10000

# Set environment variables
ENV MOJO_MODE=production
ENV PORT=10000

# Run the application using shell to expand $PORT
CMD perl app.pl daemon -l http://*:${PORT:-10000}
