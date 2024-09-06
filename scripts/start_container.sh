#!/bin/bash
set -e

docker stop $(docker ps -a -q)
Remove all the containers

docker rm $(docker ps -a -q)
# Pull the Docker image from Docker Hub
docker pull dheerajkr7866/my-python-app:5

# Run the Docker image as a container
docker run -d -p 5000:5000 dheerajkr7866/my-python-app:5