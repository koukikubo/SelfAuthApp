import { proxyRequest } from "@/app/api/v1/_lib/proxy";

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;

  return proxyRequest(request, `/api/v1/staffs/${id}/account_unlock`, "PATCH");
}
