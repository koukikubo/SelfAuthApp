"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

type Candidate = {
  id: number;
  name: string;
  type: "admin" | "staff";
};

type Props = {
  candidates: Candidate[];
};

const API_BASE =
  process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:3000";

export default function LoginForm({ candidates }: Props) {
  const router = useRouter();

  const [selected, setSelected] = useState<Candidate | null>(null);
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  // --- CSRF取得（Rails用） ---
  const fetchCsrfToken = async () => {
    const res = await fetch(`${API_BASE}/api/v1/csrf`, {
      credentials: "include",
    });
    const data = await res.json();
    return data.csrf_token;
  };

  // --- ログイン処理 ---
  const handleLogin = async () => {
    if (!selected) {
      alert("ユーザーを選択してください");
      return;
    }

    setLoading(true);

    try {
      const csrfToken = await fetchCsrfToken();
      const endpoint =
        selected.type === "admin"
          ? "/api/v1/admin/login"
          : "/api/v1/staff/login";

      const res = await fetch(`${API_BASE}${endpoint}`, {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({
          id: selected.id,
          type: selected.type,
          password,
        }),
      });

      if (!res.ok) {
        alert("ログイン失敗");
        return;
      }

      router.push("/");
    } catch (e) {
      console.error(e);
      alert("通信エラー");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card className="w-90">
      <CardHeader>
        <CardTitle>ログイン</CardTitle>
      </CardHeader>

      <CardContent className="space-y-4">
        {/* ユーザー選択 */}
        <Select
          onValueChange={(value) => {
            const [type, id] = value.split("-");

            const user = candidates.find(
              (c) => c.type === type && String(c.id) === id,
            );

            if (user) setSelected(user);
          }}
        >
          <SelectTrigger className="w-full">
            <SelectValue placeholder="ユーザーを選択" />
          </SelectTrigger>

          <SelectContent>
            {candidates.map((c) => (
              <SelectItem key={`${c.type}-${c.id}`} value={`${c.type}-${c.id}`}>
                {c.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>

        {/* パスワード */}
        <Input
          type="password"
          placeholder="パスワード"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />

        {/* ログインボタン */}
        <Button onClick={handleLogin} disabled={loading} className="w-full">
          {loading ? "ログイン中..." : "ログイン"}
        </Button>
      </CardContent>
    </Card>
  );
}
