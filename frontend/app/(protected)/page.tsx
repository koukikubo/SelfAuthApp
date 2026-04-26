import { redirect } from "next/navigation";

import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import {
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuItem,
} from "@/components/ui/dropdown-menu";

import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import LogoutButton from "@/components/auth/Logout";
import { getCurrentSession } from "@/lib/current-session";

export default async function HomePage() {
  const user = await getCurrentSession();

  // ユーザー情報が取得できない場合はログインへリダイレクト
  if (!user || !user.name) {
    redirect("/login");
  }

  return (
    <div className="min-h-screen bg-muted/40">
      {/* Header */}
      <header className="flex items-center justify-between px-6 py-4 bg-white shadow-sm">
        {/* 左 */}
        <h1 className="text-lg font-semibold">SelfAuthApp</h1>

        {/* 右 */}
        <div className="flex items-center gap-4">
          {/* ユーザー名 */}
          <div className="flex items-center gap-2">
            <Avatar className="h-8 w-8">
              <AvatarFallback>{user.name?.slice(0, 1)}</AvatarFallback>
            </Avatar>
            <span className="text-sm font-medium">{user.name}</span>
          </div>

          {/* ハンバーガーメニュー */}
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="outline" size="icon">
                ☰
              </Button>
            </DropdownMenuTrigger>

            <DropdownMenuContent align="end">
              <DropdownMenuItem asChild>
                <a href="/staffs">担当者マスタ</a>
              </DropdownMenuItem>

              <LogoutButton />
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </header>

      <Separator />

      {/* メイン */}
      <main className="p-6">
        <div className="rounded-xl bg-white p-6 shadow-sm">
          <h2 className="text-lg font-semibold mb-2">ダッシュボード</h2>
          <p className="text-sm text-muted-foreground">
            ログインに成功しました。ここから各機能にアクセスできます。
          </p>
        </div>
      </main>
    </div>
  );
}
