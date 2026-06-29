import { defineConfig, Plugin } from 'vite';
import { resolve } from 'path';
import react from '@vitejs/plugin-react';
import svgr from 'vite-plugin-svgr';
import pkg from './package.json';

const htmlVersionPlugin = (): Plugin => ({
  name: 'html-version',
  transformIndexHtml(html) {
    return html.replace('__APP_VERSION__', pkg.version);
  },
});

export default defineConfig((configEnv) => {
  const isDevelopment = configEnv.mode === 'development';

  return {
    plugins: [react(), svgr(), htmlVersionPlugin()],
    server: {
      port: 3000,
    },
    define: {
      __APP_VERSION__: JSON.stringify(pkg.version),
    },
    test: {
      globals: true,
      environment: 'happy-dom',
      setupFiles: './src/infrastructure/tests.setup.ts',
    },
    resolve: {
      alias: {
        '@atoms': resolve(__dirname, 'src', 'atoms'),
        '@assets': resolve(__dirname, 'src', 'assets'),
        '@components': resolve(__dirname, 'src', 'components'),
        '@hooks': resolve(__dirname, 'src', 'hooks'),
        '@layouts': resolve(__dirname, 'src', 'layouts'),
        '@pages': resolve(__dirname, 'src', 'pages'),
        '@providers': resolve(__dirname, 'src', 'providers'),
        '@configs': resolve(__dirname, 'src', 'configs'),
        '@@types': resolve(__dirname, 'src', 'types'),
        '@utils': resolve(__dirname, 'src', 'utils'),
      },
    },
    css: {
      modules: {
        generateScopedName: isDevelopment
          ? '[name]__[local]__[hash:base64:5]'
          : '[hash:base64:5]',
      },
    },
  };
});
