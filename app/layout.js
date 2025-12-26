import "./globals.css";
import { Outfit } from "next/font/google";
// import { ClerkProvider } from "@clerk/nextjs"; // Disabled for local dev
import Provider from "./provider";

export const metadata = {
  title: "AI-LMS - Learning Management System",
  description: "AI-Powered Learning Management System",
};

const outfit = Outfit({subsets:['latin']});

export default function RootLayout({ children }) {
  return (
    // ClerkProvider removed for local development without authentication
    <html lang="en">
      <body
        className={outfit.className}
      >
        <Provider>
          {children}
        </Provider>
      </body>
    </html>
  );
}
