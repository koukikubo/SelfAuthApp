import { NextRequest, NextResponse } from "next/server";

import { backendUrl } from "@/lib/backend-proxy";

export async function POST(request: NextRequest) {
  const upstream = await fetch(backendUrl("/api/v1/admin/login"), {
    method: "POST",
    headers: {
      Cookie: request.headers.get("cookie") ?? "",
      "Content-Type": "application/json",
      "X-CSRF-Token": request.headers.get("x-csrf-token") ?? "",
    },
    body: await request.text(),
  });

  const body = await upstream.text();
  const response = new NextResponse(body, {
    status: upstream.status,
    headers: {
      "content-type": upstream.headers.get("content-type") ?? "application/json",
    },
  });

  const setCookie = upstream.headers.get("set-cookie");
  if (setCookie) {
    response.headers.set("set-cookie", setCookie);
  }

  return response;
}
