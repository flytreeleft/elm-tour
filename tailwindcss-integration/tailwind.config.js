/** @type {import('tailwindcss').Config} */

module.exports = {
  // https://github.com/csaltos/elm-tailwindcss
  content: ["./src/**/*.elm"],
  // Note: 在任意父节点加上 [theme="dark"]，即可对其子节点启用暗黑模式。
  // 但 class 是必须指定的，否则，主题模式切换不会起作用
  // https://tailwindcss.com/docs/dark-mode#customizing-the-class-name
  darkMode: ["class", '[theme="dark"]'],
  theme: {
    extend: {},
  },
  plugins: [],
};
