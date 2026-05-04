import { proxyRequest } from "../../_lib/proxy";

export async function GET(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;
  return proxyRequest(request, `/api/v1/staffs/${id}`, "GET");
}

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;
  return proxyRequest(request, `/api/v1/staffs/${id}`, "PATCH");
}
