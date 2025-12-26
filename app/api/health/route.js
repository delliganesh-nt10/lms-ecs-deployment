import { NextResponse } from "next/server";
import { db } from "@/configs/db";

export const dynamic = 'force-dynamic';

export async function GET() {
  try {
    // Check database connection
    await db.execute("SELECT 1");

    return NextResponse.json(
      {
        status: "healthy",
        timestamp: new Date().toISOString(),
        database: "connected",
      },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      {
        status: "unhealthy",
        timestamp: new Date().toISOString(),
        database: "disconnected",
        error: error.message,
      },
      { status: 503 }
    );
  }
}
