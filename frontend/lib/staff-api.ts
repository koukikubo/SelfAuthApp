import { authFetch } from "@/lib/server-fetch";

export async function fetchStaff(id: string) {
  const res = await authFetch(`/api/v1/staffs/${id}`);

  if (!res.ok) {
    throw new Error("担当者情報取得失敗");
  }

  return res.json();
}

export async function fetchStaffs() {
  const res = await authFetch("/api/v1/staffs");

  if (!res.ok) {
    throw new Error("担当者一覧取得失敗");
  }

  return res.json();
}