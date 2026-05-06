import { authFetch } from "@/lib/api/server-fetch";

// 一人のユーザーを取得する関数
export async function fetchStaff(id: string) {
  const res = await authFetch(`/api/v1/staffs/${id}`);

  if (!res.ok) {
    throw new Error("担当者情報取得失敗");
  }

  const data = await res.json();
  return data.staff ?? data;
}

// ユーザー一覧を取得する関数
export async function fetchStaffs() {
  const res = await authFetch("/api/v1/staffs");

  if (!res.ok) {
    throw new Error("担当者一覧取得失敗");
  }

  const data = await res.json();
  return data.staffs ?? data;
}
// ----------------------------------------------------------------
// 退職者一覧を取得する関数
export async function fetchRetiredStaffs() {
  const res = await authFetch("/api/v1/staffs/retired");

  if (!res.ok) {
    throw new Error("退職者一覧取得失敗");
  }

  return res.json();
}
