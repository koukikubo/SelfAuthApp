import { StaffRole } from "./staff";

export type UserType = "admin" | "staff";

export type CurrentUser = {
  id: number;
  name: string;
  type: UserType;
  role?: StaffRole | null;
};
