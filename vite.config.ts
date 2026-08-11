// vite.config.ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
    plugins: [react(), tailwindcss()],
    css: {
        transformer: 'postcss',
    },
    build: {
        // BlockNote's Mantine stylesheet contains a media query that the
        // Linux Lightning CSS minifier rewrites incorrectly. Esbuild keeps
        // production builds deterministic across local development and CI.
        cssMinify: 'esbuild',
    },
    // server: {
    //     port: 3000,
    //     strictPort: true, // optional but recommended
    // },
})
