import type { Metadata } from "next";
import { Inter } from "next/font/google";
import React from "react";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
    title: "Seanime",
    description: "Self-hosted anime media server and torrent client",
    icons: {
        icon: "/icons/favicon.ico",
    },
};

/**
 * Root layout component for the Seanime web application.
 * Wraps all pages with common providers and global styles.
 */
export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <html lang="en" suppressHydrationWarning>
            <head>
                <meta charSet="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <meta name="theme-color" content="#000000" />
            </head>
            <body className={inter.className}>
                {children}
            </body>
        </html>
    );
}
