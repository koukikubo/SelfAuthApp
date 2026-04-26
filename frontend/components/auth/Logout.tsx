"use client";

import { DropdownMenuItem } from "@/components/ui/dropdown-menu";

export default function LogoutButton() {
  const handleLogout = async () => {
    await fetch("/api/v1/logout", {
      method: "DELETE",
      credentials: "include",
    });

    window.location.assign("/login");
  };

  return <DropdownMenuItem onClick={handleLogout}>ログアウト</DropdownMenuItem>;
}
