import { defineConfig } from "drizzle-kit";

export default defineConfig({
  dialect: "postgresql",
  schema: "./configs/schema.js",
  dbCredentials: {
    url: process.env.NEXT_PUBLIC_DATABASE_CONNECTION_STRING || "postgresql://ai_lms_user:ai_lms_password@localhost:5432/ai_lms",
  },
});
