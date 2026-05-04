import { redirect } from "next/navigation";

import StaffForm from "@/components/masters/staffs/form/staff-form";
import { getCurrentSession } from "@/lib/current-session";
import { fetchStaff } from "@/lib/staff-sever-api";
import { canManageStaff } from "@/lib/authorization";

export default async function Page({ params }: { params: { id: string } }) {
  const { id } = await params;
  const user = await getCurrentSession();

  if (!canManageStaff(user)) {
    redirect("/staff-masters");
  }

  const staff = await fetchStaff(id);

  return <StaffForm mode="edit" initialData={staff} />;
}
