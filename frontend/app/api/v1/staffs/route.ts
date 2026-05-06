import { proxyRequest } from "../_lib/proxy";

export async function POST(request: Request) {
  return proxyRequest(request, "/api/v1/staffs", "POST");
}

