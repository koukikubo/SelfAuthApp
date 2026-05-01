export type StaffRole = "viewer" | "operator" | "owner";

export type Staff = {
  name: string;
  role: StaffRole;
};

export const staffRoleLabel: Record<StaffRole, string> = {
  viewer: "閲覧のみ",
  operator: "登録・照会",
  owner: "店主権限",
} as const;
