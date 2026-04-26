const BACKEND_BASE_URL =
  process.env.BACKEND_API_BASE_URL ??
  process.env.NEXT_PUBLIC_API_BASE_URL ??
  "http://localhost:3000";

export function backendUrl(path: string): string {
  return `${BACKEND_BASE_URL}${path}`;
}
