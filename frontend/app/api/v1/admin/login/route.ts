import { proxyRequest } from "@/app/api/v1/_lib/proxy";

export async function POST(request: Request) {
  return proxyRequest(request, "/api/v1/admin/login", "POST");
}
