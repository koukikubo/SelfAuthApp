"use client";

import { useState } from "react";

import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";

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

export default function LoginForm({ candidates }: Props) {
  const [selected, setSelected] = useState<Candidate | null>(null);
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const fetchCsrfToken = async () => {
    const res = await fetch("/api/v1/csrf", { credentials: "include" });
    const data = await res.json();
    return data.csrf_token;
  };

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

      const res = await fetch(endpoint, {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({
          id: selected.id,
          type: selected.type,
          password: password.trim(),
        }),
      });

      if (!res.ok) {
        alert("ログイン失敗");
        return;
      }

      window.location.assign("/");
    } catch (e) {
      console.error(e);
      alert("通信エラー");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-muted/40">
      <Card className="w-150 shadow-lg">
        <CardHeader>
          <CardTitle className="text-xl">システムログイン</CardTitle>
          <CardDescription>
            担当者を選択してログインしてください
          </CardDescription>
        </CardHeader>

        <CardContent className="space-y-6">
          {/* 入力エリア */}
          <div className="flex gap-3">
            {/* Select */}
            <Select
              onValueChange={(value) => {
                const [type, id] = value.split("-");
                const user = candidates.find(
                  (c) => c.type === type && String(c.id) === id,
                );
                if (user) setSelected(user);
              }}
            >
              <SelectTrigger className="w-60">
                <SelectValue placeholder="担当者を選択してください" />
              </SelectTrigger>

              <SelectContent>
                {candidates.map((c) => (
                  <SelectItem
                    key={`${c.type}-${c.id}`}
                    value={`${c.type}-${c.id}`}
                  >
                    {c.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>

            {/* Password */}
            <Input
              type="password"
              placeholder="パスワードを入力してください"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="flex-1"
            />
          </div>

          {/* Button */}
          <Button onClick={handleLogin} disabled={loading} className="w-full">
            {loading ? "ログイン中..." : "ログイン"}
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
