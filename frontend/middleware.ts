import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // 静的ファイル、API、Next.js内部パスはスキップ
  if (
    pathname.startsWith("/_next") ||
    pathname.startsWith("/api") ||
    pathname.startsWith("/static") ||
    pathname.includes("favicon")
  ) {
    return NextResponse.next();
  }

  // ログインページはスキップ
  if (pathname === "/login") {
    return NextResponse.next();
  }

  // Cookieの存在確認（セッションCookieの名前はRails次第、多くは _session_id など）
  const cookies = request.headers.get("cookie") || "";
  const hasSessionCookie = cookies.includes("_session");

  // セッションがない場合はログインページへリダイレクト
  if (!hasSessionCookie) {
    return NextResponse.redirect(new URL("/login", request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * 以下のパス以外をマッチ:
     * - login
     * - _next (Next.js内部)
     * - static (静的ファイル)
     * - favicon
     */
    "/((?!login|_next|static|favicon.ico).*)",
  ],
};