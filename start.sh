#!/bin/sh

# Run database migrations (keeps schema up to date before starting)
echo "Running database migrations..."
npx medusa db:migrate

# Optional: seed only when explicitly requested (avoids reseeding on every restart)
if [ "$SEED" = "true" ]; then
  echo "Seeding database..."
  npm run seed || echo "Seeding failed, continuing..."
fi

# Start the Medusa server
# Note: Admin UI is already built during the image build in the Dockerfile
echo "Starting Medusa server..."
if [ "$NODE_ENV" = "production" ]; then
  npm run start
else
  npm run dev
fi