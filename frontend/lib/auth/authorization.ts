import type { CurrentUser } from "@/types/auth";
// 権限制御関数
export function canManageStaff(user: CurrentUser | null): boolean {
  if (!user) return false;

  return (
    user.type === "admin" || (user.type === "staff" && user.role === "owner")
  );
}
