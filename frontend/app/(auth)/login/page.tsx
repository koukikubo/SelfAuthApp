import LoginForm from "@/components/auth/LoginForm";

const API_BASE =
  process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:3000";

export default async function LoginPage() {
  // サーバー側で候補取得（SSR）
  const res = await fetch(`${API_BASE}/api/v1/login_candidates`, {
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
