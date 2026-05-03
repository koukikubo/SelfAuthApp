import type { StaffRole } from "@/types/staff";

export const staffRoleLabel: Record<StaffRole, string> = {
  viewer: "閲覧のみ",
  operator: "登録・照会",
  owner: "店主権限",
};
