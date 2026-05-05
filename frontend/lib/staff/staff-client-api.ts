import { apiFetch } from "../api/api-client";
// 担当者の作成と更新のAPIクライアント
export async function createStaff(payload: unknown) {
  return apiFetch("/api/v1/staffs", {
    method: "POST",
    body: JSON.stringify(payload),
  });
}
// 更新はIDを指定
export async function updateStaff(id: number, payload: unknown) {
  return apiFetch(`/api/v1/staffs/${id}`, {
    method: "PATCH",
    body: JSON.stringify(payload),
  });
}
// ----------------------------------------------------------------
// 担当者のアカウントロック
export async function lockStaffAccount(id: number) {
  return apiFetch(`/api/v1/staffs/${id}/account_lock`, {
    method: "PATCH",
  });
}

// 担当者のアカウントアンロック
export async function unlockStaffAccount(id: number) {
  return apiFetch(`/api/v1/staffs/${id}/account_unlock`, {
    method: "PATCH",
  });
}
