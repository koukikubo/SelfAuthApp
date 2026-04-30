import StaffMasters from "@/components/masters/staff-masters";
import { getCurrentSession } from "@/lib/current-session";
import { authFetch } from "@/lib/server-fetch";
import { redirect } from "next/navigation";

export default async function Page() {
  const res = await authFetch("/api/v1/staffs");
  const user = await getCurrentSession();
  const canAccess =
    user?.type === "admin" || (user?.type === "staff" && user.role === "owner");

  if (!canAccess) {
    redirect("/");
  }

  if (!res.ok) {
    throw new Error("担当者一覧取得失敗");
  }

  const staffs = await res.json();

  return <StaffMasters staffs={staffs} />;
}
