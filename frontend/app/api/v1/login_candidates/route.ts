import { NextResponse } from "next/server";

import { backendUrl } from "@/lib/backend-proxy";

export async function GET() {
  const upstream = await fetch(backendUrl("/api/v1/login_candidates"), {
    cache: "no-store",
  });

  const body = await upstream.text();
  return new NextResponse(body, {
    status: upstream.status,
    headers: {
      "content-type": upstream.headers.get("content-type") ?? "application/json",
    },
  });
}
