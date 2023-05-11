"use strict";

import pkg from "../package.json";

import { Elm } from "../src/Main";
import "../src/Native/webcomponents";

import "./index.css";

// Note: 采用 Browser.document 方式初始化，无需挂载到dom节点
const app = Elm.Main.init({
  // https://guide.elm-lang.org/interop/flags.html
  flags: {
    title: pkg.description,
  },
});
