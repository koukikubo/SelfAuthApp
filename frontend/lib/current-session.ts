import { cache } from "react";
import { headers } from "next/headers";

export type CurrentSession = {
  id: number;
  name: string;
  type: "admin" | "staff";
  role?: string | null;
};

function requestOrigin(headers: Headers): string {
  const protocol =
    headers.get("x-forwarded-proto") ??
    (process.env.NODE_ENV === "development" ? "http" : "https");
  const host = headers.get("x-forwarded-host") ?? headers.get("host");

  if (!host) {
    throw new Error("Host header is missing");
  }

  return `${protocol}://${host}`;
}

export const getCurrentSession = cache(async (): Promise<CurrentSession | null> => {
  const headerStore = await headers();
  const cookieHeader = headerStore.get("cookie") ?? "";

  const res = await fetch(`${requestOrigin(headerStore)}/api/v1/session`, {
    cache: "no-store",
    headers: {
      Cookie: cookieHeader,
    },
  });

  if (!res.ok) {
    return null;
  }

  return res.json();
});
