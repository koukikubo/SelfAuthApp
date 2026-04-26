import { NextRequest, NextResponse } from "next/server";

import { backendUrl } from "@/lib/backend-proxy";

async function proxySession(request: NextRequest, method: "GET" | "DELETE") {
  const upstream = await fetch(
    backendUrl(method === "DELETE" ? "/api/v1/logout" : "/api/v1/session"),
    {
      method,
      cache: "no-store",
      headers: {
        Cookie: request.headers.get("cookie") ?? "",
        "X-CSRF-Token": request.headers.get("x-csrf-token") ?? "",
      },
    },
  );

  const body = method === "DELETE" ? "" : await upstream.text();
  const response = new NextResponse(body, {
    status: upstream.status,
    headers:
      method === "DELETE"
        ? undefined
        : {
            "content-type":
              upstream.headers.get("content-type") ?? "application/json",
          },
  });

  const setCookie = upstream.headers.get("set-cookie");
  if (setCookie) {
    response.headers.set("set-cookie", setCookie);
  }

  return response;
}

export async function GET(request: NextRequest) {
  return proxySession(request, "GET");
}

export async function DELETE(request: NextRequest) {
  return proxySession(request, "DELETE");
}
