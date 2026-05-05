import { proxyRequest } from "@/app/api/v1/_lib/proxy";

export async function GET(request: Request) {
  return proxyRequest(request, "/api/v1/session", "GET");
}

export async function DELETE(request: Request) {
  return proxyRequest(request, "/api/v1/logout", "DELETE");
}
