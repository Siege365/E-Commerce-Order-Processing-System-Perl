# Perl Mojolicious E-Commerce Application
FROM perl:5.38-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy cpanfile and install dependencies
COPY cpanfile ./
RUN cpanm --notest --installdeps .

# Copy application files
COPY . .

# Create data directory for SQLite
RUN mkdir -p data

# Expose port
EXPOSE 8080

# Set environment variables
ENV MOJO_MODE=production
ENV PORT=8080

# Run the application
CMD ["perl", "app.pl", "daemon", "-l", "http://*:8080"]
