"use client";

import { AuthProvider } from "../contexts/AuthContext";

function Provider({ children }) {
  return <AuthProvider>{children}</AuthProvider>;
}

export default Provider;
