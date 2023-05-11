Elm Tour - The Reuse of Statefull Components
=========================================

本案例以集成
[ByteMD](https://github.com/bytedance/bytemd)
为例说明如何在 Elm 中通过 Web Components
机制引入**有状态**的组件，从而实现对 JS 组件生态的集成。

- [教程](https://studio.crazydan.org/blog/elm-tour-for-reuse-statefull-components)
- [演示](https://flytreeleft-elm-tour.netlify.app/reuse-statefull-components)

> 本项目基于 [tailwindcss-integration](../tailwindcss-integration/) 开发，
> 有关 Elm 与 Tailwind CSS 的集成，请见其相关说明。

## 项目创建

- 参考
  [Elm Tour - The Tailwind CSS Integration](../tailwindcss-integration/README.md#项目创建)
  初始化项目
- 新增依赖：

```bash
yarn add lit bytemd

# bytemd 插件
yarn add \
  @bytemd/plugin-breaks \
  @bytemd/plugin-gemoji \
  @bytemd/plugin-gfm \
  @bytemd/plugin-highlight \
  @bytemd/plugin-math \
  @bytemd/plugin-mermaid
yarn add \
  github-markdown-css \
  rehype-minify-whitespace

yarn elm install elm/json
```

- 参考 `src/Native/webcomponents/bytemd`
  编写 Web Components 组件，并在
  `src/Native/webcomponents/index.js` 中导出组件

## 项目开发

- 安装依赖

```bash
yarn install
```

- 本地调试

```bash
yarn dev
```

- 发布构建

```bash
yarn prod
```

> 构建产物放在 `dist` 目录下

- 安装 Elm 包

```bash
yarn elm install xxxx
```

## License

[Apache 2.0](./LICENSE)
