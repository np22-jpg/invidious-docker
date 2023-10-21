#!/usr/bin/env bash

image=$1

set -euo pipefail

stop_containers() {
    echo "Stopping containers..."
    podman stop invidious invidious-db invidious-redis
}

# For some reason this is super broken on Ubuntu
# create a network for the containers to communicate if it doesnt exist
# if ! podman network inspect invidious >/dev/null 2>&1; then
#     echo "Creating network..."
#     podman network create invidious
# fi

# Postgres
if ! podman container exists invidious-db; then
    echo "Starting postgres container..."
    podman run --rm \
        -v ./invidious/config/sql:/config/sql:Z \
        -v ./invidious/docker/init-invidious-db.sh:/docker-entrypoint-initdb.d/init-invidious-db.sh:Z \
        --name invidious-db \
        --env POSTGRES_DB=invidious \
        --env POSTGRES_USER=kemal \
        --env POSTGRES_PASSWORD=kemal \
        --network host \
        docker.io/library/postgres:latest >db.log 2>&1  &
fi

# Redis
if ! podman container exists invidious-redis; then
    echo "Running redis container..."
    podman run --rm \
        --name invidious-redis \
        --network host \
        docker.io/library/redis:latest >redis.log 2>&1 &
fi

# Wait for DBs
echo "Waiting for DBs to start..."
sleep 30

# Invidious
echo "Starting invidious container..."
podman run --rm \
    --network host \
    --name invidious \
    -v .github/config.yml:/invidious/config/config.yml \
    "$image" 2>&1 | tee invidious.log &

echo "Waiting for invidious to start..."
sleep 5
if ! podman container exists invidious; then
    echo "Invidious failed to start!"
    podman stop invidious-db invidious-redis
    exit 1
fi

# Run tests
echo "Running tests..."
if timeout 30 curl -s -o /dev/null http://127.0.0.1:3000/api/v1/comments/jNQXAC9IVRw; then
    echo "Tests passed!"
    stop_containers
    exit 0
fi
echo "Tests failed!"
stop_containers
exit 1
