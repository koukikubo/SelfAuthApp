export async function createStaff(payload: unknown) {
  return fetch(
    `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staffs`,
    {
      method: "POST",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    }
  );
}

export async function updateStaff(
  id: number,
  payload: unknown
) {
  return fetch(
    `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/staffs/${id}`,
    {
      method: "PATCH",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    }
  );
}