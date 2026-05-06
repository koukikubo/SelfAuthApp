"use client";

import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { restoreStaff, deleteStaff } from "@/lib/staff/staff-client-api";
import { staffRoleLabel } from "@/constants/staff-role";
import { Staff } from "@/types/staff";

type Props = {
  staffs: Staff[];
};

export default function RetiredStaffTable({ staffs }: Props) {
  const router = useRouter();

  return (
    <div className="space-y-6">
      {/* タイトル */}
      <div>
        <h1 className="text-2xl font-bold">退職者リスト</h1>

        <p className="text-sm text-muted-foreground">
          退職済み担当者の復元・完全削除を行います。
        </p>
      </div>

      {/* テーブル */}
      <div className="overflow-hidden rounded-xl border bg-white">
        <table className="w-full text-sm">
          <thead className="bg-muted">
            <tr className="text-left">
              <th className="p-3">氏名</th>
              <th className="p-3">権限</th>
              <th className="p-3">適用終了日</th>
              <th className="p-3">操作</th>
            </tr>
          </thead>

          <tbody>
            {staffs.map((staff) => (
              <tr key={staff.id} className="border-t">
                {/* 氏名 */}
                <td className="p-3">{staff.name}</td>

                {/* 権限 */}
                <td className="p-3">{staffRoleLabel[staff.role]}</td>

                {/* 適用終了日 */}
                <td className="p-3">{staff.effective_to ?? "ー"}</td>

                {/* 操作 */}
                <td className="flex gap-2 p-3">
                  {/* 復元 */}
                  <Button
                    size="sm"
                    onClick={async () => {
                      await restoreStaff(staff.id);

                      router.refresh();
                    }}
                  >
                    復元
                  </Button>

                  {/* 完全削除 */}
                  <Button
                    size="sm"
                    variant="destructive"
                    onClick={async () => {
                      const ok = confirm(
                        "完全削除しますか？\nこの操作は元に戻せません。",
                      );

                      if (!ok) return;

                      await deleteStaff(staff.id);

                      router.refresh();
                    }}
                  >
                    完全削除
                  </Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
