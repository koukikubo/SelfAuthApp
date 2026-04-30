export type StaffRole = 
  | "viewer"
  | "operator"
  | "owner";

  export type Staff = {
  name: string;
  role: StaffRole;
};

export const staffRoleLabel: Record<StaffRole, string> = {
  viewer: "閲覧専用",
  operator: "担当者",
  owner: "店主権限",
} as const;
