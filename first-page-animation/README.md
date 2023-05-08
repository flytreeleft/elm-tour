Elm Tour - The First Page Animation
=========================================

- [教程](https://studio.crazydan.org/blog/elm-tour-for-animation-in-the-first-page)
- [演示](./)

## 项目创建

- 安装基础的 NPM 包：

```bash
# 初始化项目，按提示补充项目信息
yarn init

# 添加依赖
yarn add --dev @babel/core @babel/preset-env
yarn add --dev webpack webpack-cli webpack-dev-middleware webpack-dev-server webpack-hot-middleware webpack-merge webpack-node-externals
yarn add --dev clean-webpack-plugin copy-webpack-plugin html-webpack-plugin terser-webpack-plugin mini-css-extract-plugin optimize-css-assets-webpack-plugin
yarn add --dev raw-loader babel-loader css-loader file-loader postcss-loader resolve-url-loader style-loader url-loader
yarn add --dev autoprefixer

# Note: 需要下载 elm 包，可能需要配置代理
yarn add --dev elm elm-analyse elm-format elm-hot-webpack-loader elm-test elm-webpack-loader
```

- 在 `package.json` 中添加脚本：

```json
  "scripts": {
    "dev": "webpack-dev-server --hot --port 4200",
    "prod": "webpack",
    "elm": "elm",
    "elm-test": "elm-test",
    "elm-analyse": "elm-analyse -s -p 4201 -o"
  },
```

- 初始化 Elm 项目：

```bash
npm run elm init
```

- 按需调整 Webpack 配置 `webpack.config.js`
- 参考本项目代码，依次准备 `src/Main.elm`、`public/index.js`、`public/index.html` 等文件

## 项目开发

- 安装依赖

```bash
yarn install
```

- 本地调试

```bash
npm run dev
```

- 发布构建

```bash
npm run prod
```

> 构建产物放在 `dist` 目录下

- 安装 Elm 包

```bash
npm run elm install xxxx
```

## License

[Apache 2.0](./LICENSE)
