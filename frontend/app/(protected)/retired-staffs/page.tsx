import RetiredStaffTable from "@/components/masters/staffs/retired-staff-table";

import { fetchRetiredStaffs } from "@/lib/staff/staff-sever-api";

export default async function Page() {
  const staffs = await fetchRetiredStaffs();

  return <RetiredStaffTable staffs={staffs} />;
}
