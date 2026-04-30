import StaffMasters from "@/components/masters/staff-masters";
import { authFetch } from "@/lib/server-fetch";

export default async function Page() {
  const res = await authFetch("/api/v1/staffs");

  if (!res.ok) {
    throw new Error("担当者一覧取得失敗");
  }

  const staffs = await res.json();

  return <StaffMasters staffs={staffs} />;
}
