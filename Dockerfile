# Development Dockerfile for Medusa
FROM node:20-alpine

# Set working directory
WORKDIR /server

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy source code
COPY . .

# Build backend + Admin UI at image build time
RUN npm run build

# Expose the port Medusa runs on
EXPOSE 9000

# Start with migrations and then the development server
CMD ["./start.sh"]