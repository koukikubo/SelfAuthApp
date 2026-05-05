export type StaffRole = "viewer" | "operator" | "owner";

export type Staff = {
  id: number;
  name: string;
  role: StaffRole;
  account_locked: boolean;
  effective_from: string;
  effective_to: string | null;
};
