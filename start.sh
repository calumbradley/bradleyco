#!/bin/sh

# Run migrations and start server
echo "Running database migrations..."
npx medusa db:migrate

echo "Seeding database..."
npm run seed || echo "Seeding failed, continuing..."

echo "Starting Medusa server..."
if [ "$NODE_ENV" = "production" ]; then
  npm run start
else
  npm run dev
fi