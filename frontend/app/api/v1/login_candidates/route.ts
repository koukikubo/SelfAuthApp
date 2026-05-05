import { proxyRequest } from "../_lib/proxy";

export async function GET(request: Request) {
  return proxyRequest(request, "/api/v1/login_candidates", "GET");
}
