"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Staff, StaffRole } from "@/types/staff";

type Props = {
  mode?: "new" | "edit";
  initialData?: Staff;
};

export default function StaffForm({ mode = "new" }: Props) {
  const router = useRouter();

  const [name, setName] = useState("");
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");
  const [role, setRole] = useState<StaffRole>("viewer");
  const [effectiveFrom, setEffectiveFrom] = useState("");
  const [effectiveTo, setEffectiveTo] = useState("");

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const isEdit = mode === "edit";

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setError("");

    if (!name.trim()) {
      setError("担当者名を入力してください。");
      return;
    }

    if (!isEdit) {
      if (!password) {
        setError("パスワードを入力してください。");
        return;
      }

      if (password !== passwordConfirmation) {
        setError("パスワード確認が一致しません。");
        return;
      }
    }

    try {
      setLoading(true);

      const res = await fetch("/api/v1/staffs", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        credentials: "include",
        body: JSON.stringify({
          staff: {
            name,
            password,
            password_confirmation: passwordConfirmation,
            role,
            effective_from: effectiveFrom,
            effective_to: effectiveTo || null,
          },
        }),
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.error || "登録に失敗しました。");
      }

      router.push("/staff-masters");
      router.refresh();
    } catch (err) {
      if (err instanceof Error) {
        setError(err.message);
      } else {
        setError("登録に失敗しました。");
      }
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="max-w-2xl mx-auto p-6">
      <Card>
        <CardHeader>
          <CardTitle>{isEdit ? "担当者情報編集" : "担当者新規登録"}</CardTitle>
        </CardHeader>

        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-6">
            {error && (
              <div className="rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
                {error}
              </div>
            )}

            <div className="space-y-2">
              <Label htmlFor="name">担当者名</Label>
              <Input
                id="name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="例: 大阪太郎"
              />
            </div>

            {!isEdit && (
              <>
                <div className="space-y-2">
                  <Label htmlFor="password">パスワード</Label>
                  <Input
                    id="password"
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="passwordConfirmation">パスワード確認</Label>
                  <Input
                    id="passwordConfirmation"
                    type="password"
                    value={passwordConfirmation}
                    onChange={(e) => setPasswordConfirmation(e.target.value)}
                  />
                </div>
              </>
            )}

            <div className="space-y-2">
              <Label htmlFor="role">権限</Label>
              <select
                id="role"
                value={role}
                onChange={(e) => setRole(e.target.value as StaffRole)}
                className="w-full rounded-md border px-3 py-2 text-sm"
              >
                <option value="viewer">閲覧専用</option>
                <option value="operator">担当者</option>
                <option value="owner">店主権限</option>
              </select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="effectiveFrom">適用開始日</Label>
              <Input
                id="effectiveFrom"
                type="date"
                value={effectiveFrom}
                onChange={(e) => setEffectiveFrom(e.target.value)}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="effectiveTo">適用終了日（任意）</Label>
              <Input
                id="effectiveTo"
                type="date"
                value={effectiveTo}
                onChange={(e) => setEffectiveTo(e.target.value)}
              />
            </div>

            <div className="flex gap-3 pt-2">
              <Button type="submit" disabled={loading}>
                {loading ? "保存中..." : "登録する"}
              </Button>

              <Button
                type="button"
                variant="outline"
                onClick={() => router.push("/staff-masters")}
              >
                戻る
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
