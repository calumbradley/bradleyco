import { loadEnv, defineConfig } from "@medusajs/framework/utils";

// Load envs for the current NODE_ENV
loadEnv(process.env.NODE_ENV || "development", process.cwd());

module.exports = defineConfig({
  // Project-level configuration
  projectConfig: {
    // Database connection (required)
    databaseUrl: process.env.DATABASE_URL,

    // CORS for store/admin/auth (from docs)
    http: {
      storeCors: process.env.STORE_CORS!, // e.g. https://store.example.com
      adminCors: process.env.ADMIN_CORS!, // e.g. https://admin.example.com
      authCors: process.env.AUTH_CORS!, // comma-separated URLs
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    },

    // Add Redis URL as per docs (used for sessions/workflows/etc.)
    redisUrl: process.env.REDIS_URL,

    // Set worker mode from env: "server" | "worker" | "shared"
    workerMode: process.env.MEDUSA_WORKER_MODE as
      | "shared"
      | "worker"
      | "server",

    // Optional driver options (keep your existing)
    databaseDriverOptions: {
      ssl: false,
      sslmode: "disable",
    },
  },

  // Admin configuration:
  // - disable in worker mode
  // - set backendUrl so the admin points to the server instance URL
  admin: {
    disable: process.env.DISABLE_MEDUSA_ADMIN === "true",
    backendUrl: process.env.MEDUSA_BACKEND_URL, // e.g. https://api.example.com
  },
});
