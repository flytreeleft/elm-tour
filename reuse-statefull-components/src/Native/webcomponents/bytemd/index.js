import { LitElement } from "lit";

// https://github.com/bytedance/bytemd
import { Editor } from "bytemd";
import "bytemd/dist/index.css";
import "github-markdown-css/github-markdown.css";

import gfm from "@bytemd/plugin-gfm";
import breaks from "@bytemd/plugin-breaks";
import gemoji from "@bytemd/plugin-gemoji";
import mermaid from "@bytemd/plugin-mermaid";
import rehypeMinifyWhitespace from "rehype-minify-whitespace";

import highlight from "@bytemd/plugin-highlight";
import "highlight.js/styles/github.css";

import math from "@bytemd/plugin-math";
// Note: 需将其 fonts 复制到站点 /fonts 下
import "katex/dist/katex.css";

// Note: 框架的 css 机制在不使用 shadow dom 时不可用，
// 只能以 import 方式全局引入样式
import "./index.css";

const commonProperties = {
  bytemd: { state: true },
  // attributes
  value: { attribute: true },
  innerClass: { attribute: "inner-class" },
  // split, tab, auto
  mode: { attribute: true },
  lang: { attribute: true },
  placeholder: { attribute: true },
};

export class ByteMDEditor extends LitElement {
  static properties = commonProperties;

  createRenderRoot() {
    return this;
  }

  firstUpdated() {
    this.bytemd = new Editor({
      target: this.renderRoot,
      props: {
        value: this.value,
        mode: this.mode,
        placeholder: this.placeholder,
        locale: bytemdLocales[this.lang],
        plugins: plugins(this.lang),
        // https://codemirror.net/5/doc/manual.html#config
        editorConfig: {
          autofocus: true,
          lineNumbers: true,
        },
      },
    });

    updateStyle(this.renderRoot, this.innerClass);

    this.bytemd.$on("change", (e) => {
      const value = e.detail.value;
      this.value = value;
      this.bytemd.$set({ value });

      // https://lit.dev/docs/components/events/#dispatching-events
      // Note: 需将 value 放在新的结构体中，
      // 否则，在监听端会在最后一次仅收到最后输入的内容
      const detail = { value };
      const event = new CustomEvent("change", {
        detail,
        bubbles: true,
        composed: true,
        cancelable: true,
      });
      this.dispatchEvent(event);
    });
  }

  updated(changedProperties) {
    updateProperties(this, changedProperties);
  }
}

// Note: 组件名称中必须包含连字符
customElements.define("bytemd-editor", ByteMDEditor);

// https://medium.com/dailyjs/leveraging-webpack-power-to-import-all-files-from-one-folder-cddedd3201b3
const bytemdLocales = loadPluginLocales(
  require.context("/node_modules/bytemd/locales", false, /\.json$/)
);
const gfmLocales = loadPluginLocales(
  require.context("/node_modules/@bytemd/plugin-gfm/locales", false, /\.json$/)
);
const mathLocales = loadPluginLocales(
  require.context("/node_modules/@bytemd/plugin-math/locales", false, /\.json$/)
);
const mermaidLocales = loadPluginLocales(
  require.context(
    "/node_modules/@bytemd/plugin-mermaid/locales",
    false,
    /\.json$/
  )
);

function loadPluginLocales(ctx) {
  const locales = {};
  ctx
    .keys()
    .filter((name) => name.startsWith("./"))
    .forEach((name) => {
      const locale = name.replaceAll(/^\.\/(.+)\.json$/g, "$1");
      locales[locale] = ctx(name);
    });
  return locales;
}

function plugins(lang) {
  return [
    gfm({
      locale: gfmLocales[lang],
    }),
    breaks(),
    gemoji(),
    highlight(),
    math({
      locale: mathLocales[lang],
      // https://github.com/KaTeX/KaTeX/issues/2796
      katexOptions: { output: "html" },
    }),
    mermaid({
      locale: mermaidLocales[lang],
    }),
    {
      // 清除生成的 HTML 中标签间的换行符，以避免在展示页面中因为换行符而出现不可见的空白行
      // https://github.com/rehypejs/rehype-minify/tree/main/packages/rehype-minify-whitespace
      rehype(processor) {
        processor.use(rehypeMinifyWhitespace);
        return processor;
      },
    },
  ];
}

function updateProperties(scope, changedProperties) {
  Object.keys(commonProperties).forEach((prop) => {
    if (!changedProperties.has(prop)) {
      return;
    }

    const value = scope[prop];
    if (prop === "innerClass") {
      updateStyle(scope.renderRoot, value);
    } else if (prop === "lang") {
      scope.bytemd.$set({
        locale: bytemdLocales[value],
        plugins: plugins(value),
      });
    } else {
      scope.bytemd.$set({ [prop]: value });
    }
  });
}

function updateStyle(root, class_) {
  const classList = root.firstElementChild.classList;
  if (root.__user_classes__ && root.__user_classes__.length > 0) {
    root.__user_classes__.forEach((s) => classList.remove(s));
    root.__user_classes__ = [];
  }

  const classes = class_ ? class_.trim().split(/\s+/g) : [];
  if (classes.length > 0) {
    root.__user_classes__ = classes;
    classes.forEach((s) => classList.add(s));
  }
}
