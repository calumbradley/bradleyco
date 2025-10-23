# Base Node image (alpine for small footprint)
FROM node:20-alpine

# All paths below are relative to /server
WORKDIR /server

# 1) Install deps needed to BUILD the project (includes dev deps)
#    Use package-lock to ensure reproducible installs
COPY package.json package-lock.json ./
RUN npm ci

# 2) Copy the full source (server + admin) into the image
COPY . .

# 3) Build production artifacts (per Medusa docs: `medusa build`)
#    - Produces .medusa/server and the Admin UI build
RUN npm run build

# 4) Install ONLY runtime deps for the built server package
#    - The built server has its own package.json in .medusa/server
RUN cd .medusa/server && npm ci --omit=dev

# 5) Container runtime configuration
ENV NODE_ENV=production
EXPOSE 9000

# 6) Start from the built server output (serves API + Admin in prod)
CMD ["sh", "-lc", "cd .medusa/server && npm run start"]