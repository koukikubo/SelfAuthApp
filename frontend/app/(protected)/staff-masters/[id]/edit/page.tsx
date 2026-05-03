import { redirect } from "next/navigation";

import StaffForm from "@/components/masters/staffs/form/staff-form";
import { getCurrentSession } from "@/lib/current-session";
import { fetchStaff } from "@/lib/staff-api";
import { canManageStaff } from "@/lib/authorization";

export default async function Page({ params }: { params: { id: string } }) {
  const user = await getCurrentSession();

  if (!canManageStaff(user)) {
    redirect("/staff-masters");
  }

  const staff = await fetchStaff(params.id);

  return <StaffForm mode="edit" initialData={staff} />;
}
