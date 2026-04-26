import LoginForm from "@/components/auth/LoginForm";
import { headers } from "next/headers";

export default async function LoginPage() {
  const headerStore = await headers();
  const host = headerStore.get("host");
  const protocol = process.env.NODE_ENV === "development" ? "http" : "https";

  const res = await fetch(`${protocol}://${host}/api/v1/login_candidates`, {
    cache: "no-store",
  });

  if (!res.ok) {
    throw new Error("login_candidates の取得に失敗");
  }

  const candidates = await res.json();

  return (
    <div className="min-h-screen flex items-center justify-center bg-background">
      <LoginForm candidates={candidates} />
    </div>
  );
}
