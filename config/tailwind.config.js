const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        'violet-blue': '#1747c7',
        'royal-blue': '#175ff2',
        'blue-crayola': '#3575f3',
        primary: {
          DEFAULT: '#175ff2',
          dark: '#1747c7',
          light: '#3575f3',
        },
        'blue-light': {
          bg: '#e8f0ff',
          border: '#b8d1ff',
        }
      },
      fontFamily: {
        sans: ['Helvetica', 'Arial', ...defaultTheme.fontFamily.sans],
        heading: ['Roboto', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
}