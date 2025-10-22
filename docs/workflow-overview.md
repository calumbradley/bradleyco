# Workflow Overview

This document explains how the Docker build and deployment workflows interact in the BradleyCo project.

## Dockerfile

The `Dockerfile` defines the containerized application environment:

- **Base Image**: Uses `node:20-alpine` for a lightweight Node.js 20 runtime
- **Working Directory**: Sets `/server` as the working directory inside the container
- **Copy Package Files**: Copies `package.json` and `package-lock.json` first (leverages Docker layer caching)
- **Install Dependencies**: Runs `npm install` to install all project dependencies inside the image during build time, ensuring the container has everything it needs to run
- **Copy Source Code**: Copies the entire application source code into the container
- **Expose Port**: Exposes port 9000 for the Medusa server
- **Startup Command**: Executes `./start.sh` to run database migrations and start the development server

The key step is `npm install`, which ensures all dependencies are baked into the Docker image. This means the image is self-contained and ready to run without needing to install dependencies at deployment time.

## build-image.yml

The `build-image.yml` workflow automates Docker image creation and publishing:

- **Trigger**: Runs automatically on pushes to the `master` branch or manually via `workflow_dispatch`
- **Authentication**: Logs into GitHub Container Registry (GHCR) using the repository owner's credentials and `GITHUB_TOKEN`
- **Build Process**: Uses Docker Buildx to build the image from the `Dockerfile` in the repository root
- **Push to Registry**: Pushes the built image to GHCR with the tag `ghcr.io/calumbradley/bradleyco/medusa:latest`
- **Result**: A production-ready Docker image containing all dependencies (from `npm install`) and source code is stored in GHCR

This workflow ensures that every push to master creates a fresh, deployable image without manual intervention.

## deploy.yml

The `deploy.yml` workflow handles production deployment:

- **Trigger**: Runs manually via `workflow_dispatch` only
- **Connection**: Uses SSH to connect to a DigitalOcean droplet (production server)
- **Docker Setup**: Installs Docker on the server if not already present
- **GHCR Authentication**: Logs into GHCR to pull private images (if configured)
- **Repository Sync**: Clones or updates the repository on the server to get the latest `docker-compose.prod.yml`
- **Image Pull**: Runs `docker compose -f docker-compose.prod.yml pull` to fetch the pre-built image from GHCR
- **Deployment**: Runs `docker compose -f docker-compose.prod.yml up -d` to start the containers
- **No Rebuild**: The deployment uses the image built by `build-image.yml` - it does NOT rebuild from source

The `docker-compose.prod.yml` references `ghcr.io/calumbradley/bradleyco/medusa:latest`, which is the image created by the build workflow.

## Workflow Interaction Summary

1. **Build Phase**: When code is pushed to `master`, `build-image.yml` builds a Docker image using the `Dockerfile` (which runs `npm install`) and pushes it to GHCR
2. **Deploy Phase**: When deployment is triggered manually, `deploy.yml` pulls the pre-built image from GHCR and starts it using Docker Compose
3. **Separation of Concerns**: Building and deployment are separate processes, allowing faster deployments and ensuring consistency between environments

This architecture ensures that the production environment always runs a tested, immutable image rather than building from source on the production server.
