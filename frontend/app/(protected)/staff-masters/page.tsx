import StaffMasters from "@/components/masters/staffs/staff-masters";
import { canManageStaff } from "@/lib/auth/authorization";
import { getCurrentSession } from "@/lib/auth/current-session";
import { authFetch } from "@/lib/api/server-fetch";
import { redirect } from "next/navigation";

export default async function Page() {
  const res = await authFetch("/api/v1/staffs");
  const user = await getCurrentSession();

  if (!canManageStaff(user)) {
    redirect("/");
  }

  if (!res.ok) {
    throw new Error("担当者一覧取得失敗");
  }

  const staffs = await res.json();

  return <StaffMasters staffs={staffs} />;
}
