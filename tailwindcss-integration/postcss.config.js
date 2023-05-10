// https://github.com/csaltos/elm-tailwindcss
// https://tailwindcss.com/docs/installation/using-postcss
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
    // 缩减 css 文件大小
    // https://cssnano.co/
    cssnano: {
      preset: [
        "default",
        {
          discardComments: {
            removeAll: true,
          },
        },
      ],
    },
  },
};
