# Workflow Overview

This document explains how the Dockerfile, build-image.yml, and deploy.yml workflows interact to build and deploy the Medusa application.

## Dockerfile

The Dockerfile defines the application container image:

- **Base Image**: Uses `node:20-alpine` for a lightweight Node.js environment
- **Working Directory**: Sets `/server` as the working directory for all operations
- **Package Files**: Copies `package.json` and `package-lock.json` first to leverage Docker layer caching
- **npm install**: Installs all dependencies defined in package.json, ensuring the image contains everything needed to run the application
- **Source Code**: Copies the application source code into the image
- **Port Exposure**: Exposes port 9000 for the Medusa server
- **Startup Command**: Runs `./start.sh` to start the application with migrations

## build-image.yml

This workflow builds and pushes the Docker image to GitHub Container Registry (GHCR):

- **Trigger**: Runs automatically on pushes to the master branch or manually via workflow_dispatch
- **Build Process**: 
  - Checks out the repository code
  - Sets up Docker Buildx for advanced build features
  - Authenticates to GHCR using the repository owner's credentials
  - Builds the Docker image using the Dockerfile
  - Tags the image as `ghcr.io/calumbradley/bradleyco/medusa:latest`
  - Pushes the built image to GHCR for later use

## deploy.yml

This workflow deploys the pre-built Docker image to production:

- **Trigger**: Runs manually via workflow_dispatch
- **Deployment Process**:
  - Connects to the production server via SSH
  - Ensures Docker is installed on the server
  - Authenticates to GHCR to access private images
  - Clones or updates the repository on the production server
  - Pulls the pre-built image from GHCR using `docker compose -f docker-compose.prod.yml pull`
  - Starts the application using `docker compose -f docker-compose.prod.yml up -d`
- **Key Point**: The image is NOT rebuilt during deployment; it uses the pre-built image from GHCR, ensuring consistency and faster deployments

## Workflow Interaction

1. **Build Phase**: When code is pushed to master, `build-image.yml` builds the Docker image using the Dockerfile and pushes it to GHCR
2. **Deploy Phase**: When deployment is triggered, `deploy.yml` pulls the pre-built image from GHCR and deploys it to production
3. **Separation of Concerns**: Building and deployment are separate processes, allowing for tested, consistent deployments without rebuild time
