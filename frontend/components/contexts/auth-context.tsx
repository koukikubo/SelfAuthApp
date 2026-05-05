"use client";

import { CurrentUser } from "@/types/auth";
import { createContext, useContext } from "react";

const AuthContext = createContext<CurrentUser | null>(null);

type Props = {
  user: CurrentUser;
  children: React.ReactNode;
};

export function AuthProvider({ user, children }: Props) {
  return <AuthContext.Provider value={user}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  return useContext(AuthContext);
}
