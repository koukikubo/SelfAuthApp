import { redirect } from "next/navigation";

import StaffForm from "@/components/masters/staffs/form/staff-form";
import { getCurrentSession } from "@/lib/auth/current-session";
import { fetchStaff } from "@/lib/staff/staff-sever-api";
import { canManageStaff } from "@/lib/auth/authorization";

export default async function Page({ params }: { params: { id: string } }) {
  const { id } = await params;
  const user = await getCurrentSession();

  if (!canManageStaff(user)) {
    redirect("/staff-masters");
  }

  const staff = await fetchStaff(id);

  return <StaffForm mode="edit" initialData={staff} />;
}
