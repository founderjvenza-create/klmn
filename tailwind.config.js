/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#dc6625',
        secondary: '#487fc5',
        accent: '#dc6625',
      },
    },
  },
  plugins: [],
}
