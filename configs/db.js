import { neon } from "@neondatabase/serverless";
import { drizzle } from "drizzle-orm/neon-http";

const connectionString = process.env.NEXT_PUBLIC_DATABASE_CONNECTION_STRING || "postgresql://ai_lms_user:ai_lms_password@localhost:5432/ai_lms";

const sql = neon(connectionString);
export const db = drizzle(sql);

