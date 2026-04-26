import { redirect } from "next/navigation";
import { getCurrentSession } from "@/lib/current-session";

export default async function ProtectedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const user = await getCurrentSession();

  if (!user) {
    redirect("/login");
  }

  return <>{children}</>;
}
