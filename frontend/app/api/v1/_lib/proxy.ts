import { backendUrl } from "@/lib/api/backend-proxy";
import { HttpMethod } from "../_types/method";
import { NextResponse } from "next/server";

export async function proxyRequest(
  request: Request,
  path: string,
  method: HttpMethod,
) {
  const headers: Record<string, string> = {
    Cookie: request.headers.get("cookie") ?? "",
    Accept: "application/json",
  };

  const csrfToken = request.headers.get("x-csrf-token");
  if (csrfToken) {
    headers["X-CSRF-Token"] = csrfToken;
  }
  const upstream = await fetch(backendUrl(path), {
    method,
    headers: {
      Cookie: request.headers.get("cookie") ?? "",
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken ?? "",
    },
    body:
      method === "GET" || method === "DELETE"
        ? undefined
        : await request.text(),
  });

  const body = await upstream.text();

  const response = new NextResponse(body, {
    status: upstream.status,
    headers: {
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
