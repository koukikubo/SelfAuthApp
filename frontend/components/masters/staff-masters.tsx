"use client";

import { Button } from "@/components/ui/button";
import { staffRoleLabel } from "@/lib/staff-role";

type Props = {
  staffs: Staff[];
};

type Staff = {
  id: number;
  name: string;
  role: keyof typeof staffRoleLabel;
  locked: boolean;
  effective_to: string;
};

export default function StaffMasters({ staffs }: Props) {
  return (
    <div className="space-y-6">
      {/* タイトル */}
      <div>
        <h1 className="text-2xl font-bold">担当者マスタ</h1>
        <p className="text-sm text-muted-foreground">
          担当者情報の登録・編集・権限制御を行います。
        </p>
      </div>

      <div className="flex justify-between gap-4">
        <Button>新規登録</Button>
      </div>

      {/* テーブル */}
      <div className="rounded-xl border bg-white overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-muted">
            <tr className="text-left">
              <th className="p-3">氏名</th>
              <th className="p-3">権限</th>
              <th className="p-3">状態</th>
              <th className="p-3">適用終了日</th>
              <th className="p-3">操作</th>
            </tr>
          </thead>

          <tbody>
            {staffs.map((staff) => (
              <tr key={staff.id} className="border-t">
                <td className="p-3">{staff.name}</td>
                <td className="p-3">{staffRoleLabel[staff.role]}</td>

                <td className="p-3">
                  {staff.locked ? (
                    <span className="text-red-500">ロック中</span>
                  ) : (
                    <span className="text-green-600">有効</span>
                  )}
                </td>

                <td className="p-3">{staff.effective_to ?? "ー"}</td>

                <td className="p-3 flex gap-2">
                  <Button size="sm" variant="outline">
                    編集
                  </Button>

                  {staff.locked ? (
                    <Button size="sm">解除</Button>
                  ) : (
                    <Button size="sm" variant="destructive">
                      ロック
                    </Button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
