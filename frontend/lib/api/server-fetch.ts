// SSR用 共通Fetch関数
import { cookies } from "next/headers";

export async function authFetch(path: string) {
  const cookieStore = await cookies();

  return fetch(`${process.env.NEXT_PUBLIC_API_BASE_URL}${path}`, {
    headers: {
      Cookie: cookieStore.toString(),
    },
    cache: "no-store",
  });
}
