// CSRF付きfetch
let csrfToken: string | null = null;

// CSRF取得
async function getCsrfToken(): Promise<string> {
  // 既に取得済みならそれを返す（キャッシュ）
  if (csrfToken) return csrfToken;
  // Next.jsのProxy経由でRailsのCSRF取得APIを叩く
  const res = await fetch("/api/v1/csrf", {
    credentials: "include",
  });
  // 通信失敗
  if (!res.ok) {
    throw new Error("CSRF取得失敗");
  }

  const data = await res.json();
  const token = data.csrf_token;

  if (!token) {
    throw new Error("CSRFトークンがレスポンスに含まれていません");
  }

  csrfToken = token;

  return token;
}

// 共通API
export async function apiFetch(path: string, options: RequestInit = {}) {
  // HTTPメソッドを取得（未指定ならGET）
  const method = (options.method ?? "GET").toUpperCase();
  // ヘッダーを生成（既存のheadersを引き継ぐ）
  const headers = new Headers(options.headers);
  // bodyがある場合、Content-Typeが未指定ならJSONをセット
  if (options.body && !headers.has("Content-Type")) {
    headers.set("Content-Type", "application/json");
  }
  //重要：POST/PATCH/DELETEなどの「破壊的操作」だけCSRFを付与
  // GETは安全なので不要
  if (!["GET", "HEAD"].includes(method)) {
    const token = await getCsrfToken();
    headers.set("X-CSRF-Token", token);
  }

  // 実際のAPIリクエスト
  const res = await fetch(path, {
    ...options,
    method,
    credentials: "include", // Cookie（session）を送る（Rails認証必須）
    headers,
  });

  // CSRFトークンが無効になった場合の対処
  // セッション切れや不整合時に再取得できるようにする
  if (res.status === 422 || res.status === 403) {
    csrfToken = null;
  }

  return res;
}
