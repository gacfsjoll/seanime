/** @type {import('next').NextConfig} */
const nextConfig = {
    // Output as standalone for Docker/binary bundling
    output: process.env.NEXT_OUTPUT === 'export' ? 'export' : undefined,

    // Disable image optimization for standalone builds
    images: {
        unoptimized: true,
        remotePatterns: [
            {
                protocol: 'https',
                hostname: 's4.anilist.co',
            },
            {
                protocol: 'https',
                hostname: 'img.anili.st',
            },
            {
                protocol: 'https',
                hostname: 'artworks.thetvdb.com',
            },
            {
                protocol: 'https',
                hostname: '*.simkl.com',
            },
            {
                protocol: 'https',
                hostname: 'image.tmdb.org',
            },
        ],
    },

    // Rewrites for API proxying in development
    async rewrites() {
        if (process.env.NODE_ENV === 'development') {
            return [
                {
                    source: '/api/:path*',
                    destination: `http://localhost:${process.env.NEXT_PUBLIC_SERVER_PORT || 43211}/api/:path*`,
                },
            ]
        }
        return []
    },

    // Webpack configuration
    webpack: (config, { isServer }) => {
        // Handle SVG imports
        config.module.rules.push({
            test: /\.svg$/,
            use: ['@svgr/webpack'],
        })

        return config
    },

    // Experimental features
    experimental: {
        // Enable server actions
        serverActions: {
            allowedOrigins: ['localhost:43211', 'localhost:43214'],
        },
    },

    // Environment variables exposed to the browser
    env: {
        NEXT_PUBLIC_SERVER_PORT: process.env.NEXT_PUBLIC_SERVER_PORT || '43211',
    },

    // Trailing slash configuration
    trailingSlash: false,

    // React strict mode
    reactStrictMode: false,

    // Disable x-powered-by header
    poweredByHeader: false,
}

export default nextConfig
