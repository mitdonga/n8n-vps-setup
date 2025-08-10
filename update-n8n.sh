#!/bin/bash

set -e  # Exit script if any command fails

echo "Connecting to n8n container to check current version..."
docker exec -it n8n-n8n-1 n8n -v

echo "Pulling latest n8n Docker image..."
docker compose pull

echo "Stopping existing containers..."
docker compose down

echo "Starting containers..."
docker compose up -d 
sleep 3

echo "Scaling n8n-worker to 5 instances..."
docker compose up -d --scale n8n-worker=5

echo "Verifying n8n version after update..."
docker exec -it n8n-n8n-1 n8n -v

echo "n8n update process completed successfully!"