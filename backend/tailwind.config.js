/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#fef7ed',
          100: '#fdedd5',
          200: '#fbd7aa',
          300: '#f8bb74',
          400: '#f4943c',
          500: '#f17316',
          600: '#e2570c',
          700: '#bb400c',
          800: '#953312',
          900: '#792c12',
        },
        brown: {
          50: '#fdf8f6',
          100: '#f2e8e5',
          200: '#eaddd7',
          300: '#e0cec7',
          400: '#d2bab0',
          500: '#bfa094',
          600: '#a18072',
          700: '#977669',
          800: '#7c5f56',
          900: '#5d4037',
        }
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
