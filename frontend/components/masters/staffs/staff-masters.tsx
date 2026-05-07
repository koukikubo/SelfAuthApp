"use client";

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";
import { staffRoleLabel } from "@/constants/staff-role";
import {
  lockStaffAccount,
  unlockStaffAccount,
  restoreStaff,
  deleteStaff,
  retireStaff,
} from "@/lib/staff/staff-client-api";
import { Staff } from "@/types/staff";
import Link from "next/link";
import { useRouter } from "next/navigation";

type Props = {
  staffs: Staff[];
  retiredMode?: boolean;
};

export default function StaffMasters({ staffs, retiredMode = false }: Props) {
  const router = useRouter();
  return (
    <div className="space-y-6">
      {/* タイトル */}
      <div>
        <h1 className="text-2xl font-bold">
          {retiredMode ? "退職者リスト" : "担当者マスタ"}
        </h1>
        <p className="text-sm text-muted-foreground">
          {retiredMode
            ? "退職済み担当者の復元・完全削除を行います。"
            : "担当者情報の登録・編集・権限制御を行います。"}
        </p>
      </div>

      <div className="flex justify-between gap-4">
        {retiredMode ? (
          <Button asChild variant="outline">
            <Link href="/staff-masters">担当者マスタへ戻る</Link>
          </Button>
        ) : (
          <>
            <Button asChild>
              <Link href="/staff-masters/new">新規登録</Link>
            </Button>

            <Button asChild variant="outline">
              <Link href="/retired-staffs">退職者リスト</Link>
            </Button>
          </>
        )}
      </div>

      {/* テーブル */}
      <div className="rounded-xl border bg-white overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-muted">
            <tr className="text-left">
              <th className="p-3">氏名</th>
              <th className="p-3">権限</th>
              <th className="p-3">状態</th>
              <th className="p-3">退職日</th>
              <th className="p-3">操作</th>
            </tr>
          </thead>

          <tbody>
            {staffs.map((staff) => (
              <tr key={staff.id} className="border-t">
                <td className="p-3">{staff.name}</td>
                <td className="p-3">{staffRoleLabel[staff.role]}</td>

                <td className="p-3">
                  {staff.account_locked ? (
                    <span className="text-red-500">ロック中</span>
                  ) : (
                    <span className="text-green-600">有効</span>
                  )}
                </td>

                <td className="p-3">{staff.effective_to ?? "ー"}</td>

                <td className="p-3 flex gap-2">
                  {retiredMode ? (
                    <>
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
                          await deleteStaff(staff.id);
                          router.refresh();
                        }}
                      >
                        完全削除
                      </Button>
                    </>
                  ) : (
                    <>
                      <Link href={`/staff-masters/${staff.id}/edit`}>
                        <Button size="sm" variant="outline">
                          編集
                        </Button>
                      </Link>

                      {staff.account_locked ? (
                        <Button
                          size="sm"
                          onClick={async () => {
                            await unlockStaffAccount(staff.id);
                            router.refresh();
                          }}
                        >
                          解除
                        </Button>
                      ) : (
                        <>
                          <Button
                            size="sm"
                            variant="destructive"
                            onClick={async () => {
                              await lockStaffAccount(staff.id);
                              router.refresh();
                            }}
                          >
                            ロック
                          </Button>
                          <AlertDialog>
                            <AlertDialogTrigger asChild>
                              <Button size="sm" variant="destructive">
                                退職
                              </Button>
                            </AlertDialogTrigger>

                            <AlertDialogContent>
                              <AlertDialogHeader>
                                <AlertDialogTitle>
                                  担当者を退職状態にしますか？
                                </AlertDialogTitle>

                                <AlertDialogDescription>
                                  この操作を行うとログインできなくなります。
                                </AlertDialogDescription>
                              </AlertDialogHeader>

                              <AlertDialogFooter>
                                <AlertDialogCancel>
                                  キャンセル
                                </AlertDialogCancel>

                                <AlertDialogAction
                                  onClick={async () => {
                                    await retireStaff(staff.id);
                                    router.refresh();
                                  }}
                                >
                                  退職する
                                </AlertDialogAction>
                              </AlertDialogFooter>
                            </AlertDialogContent>
                          </AlertDialog>
                        </>
                      )}
                    </>
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
