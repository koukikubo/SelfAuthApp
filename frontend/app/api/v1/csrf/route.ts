import { NextRequest, NextResponse } from "next/server";

import { backendUrl } from "@/lib/backend-proxy";

export async function GET(request: NextRequest) {
  const upstream = await fetch(backendUrl("/api/v1/csrf"), {
    cache: "no-store",
    headers: {
      Cookie: request.headers.get("cookie") ?? "",
    },
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
