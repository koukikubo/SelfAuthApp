import { redirect } from "next/navigation";
import { getCurrentSession } from "@/lib/auth/current-session";
import { AuthProvider } from "@/components/contexts/auth-context";

export default async function ProtectedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const user = await getCurrentSession();

  if (!user) {
    redirect("/login");
  }
  return <AuthProvider user={user}>{children}</AuthProvider>;
}
