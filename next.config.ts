import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  // Pin the workspace root: there is a stray package-lock.json in a parent
  // directory that Turbopack would otherwise try to use.
  turbopack: { root: __dirname },
}

export default nextConfig
