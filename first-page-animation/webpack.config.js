// https://github.com/simonh1000/elm-webpack-starter/blob/master/webpack.config.js
const fs = require("fs");
const path = require("path");
const { merge } = require("webpack-merge");

const TerserPlugin = require("terser-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const HTMLWebpackPlugin = require("html-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

// Production CSS assets - separate, minimised file
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");

const MODE =
  process.env.npm_lifecycle_event === "prod" ? "production" : "development";
const WEB_CONTEXT_ROOT_PATH = process.env.WEB_CONTEXT_ROOT_PATH;

const webCtxRootPath = WEB_CONTEXT_ROOT_PATH
  ? WEB_CONTEXT_ROOT_PATH.replace(/\/+$/, "") + "/"
  : "/";
const withDebug = !process.env.npm_config_nodebug && MODE === "development";
// this may help for Yarn users
// const withDebug = !npmParams.includes("--nodebug");
console.log(
  "\x1b[36m%s\x1b[0m",
  `** elm-webpack-starter: mode "${MODE}"` +
    `, withDebug: ${withDebug}` +
    `, webCtxRootPath: "${webCtxRootPath}"` +
    `\n`
);

const srcDir = "src";
const publicDir = "public";
const __ROOT_DIR__ = __dirname;
function filepath(...paths) {
  return path.join(__ROOT_DIR__, ...paths);
}

const packageJson = require("./package.json");
const loadingSvg = fs.readFileSync(
  filepath(publicDir, "assets/img/loading.svg"),
  "utf-8"
);

const common = {
  mode: MODE,
  entry: filepath(publicDir, "index.js"),
  output: {
    path: filepath("dist"),
    // 必须指定，否则，动态导入的 js 路径采用的是相对路径，
    // 在浏览器路由到其他子路径时，会出现 js 无法加载的问题
    publicPath: webCtxRootPath,
    // FIXME webpack -p automatically adds hash when building for production
    filename: MODE === "production" ? "[name]-[contenthash].js" : "index.js",
  },
  plugins: [
    new HTMLWebpackPlugin({
      // 自定义的扩展配置，可在模板文件中通过
      // <%= htmlWebpackPlugin.options.xxxx %> 引用配置数据
      author: packageJson.author,
      description: packageJson.description,
      loading: Buffer.from(loadingSvg, "utf-8").toString("base64"),

      // 指定 html 模板文件位置
      template: filepath(publicDir, "index.html"),
      publicPath: webCtxRootPath,

      // 禁用 css 与 js 自动注入机制，以便于在模板内控制资源的注入位置，
      // 确保 js 始终在 body 标签内加载，降低 js 加载对首页加载动画的影响
      inject: false,
    }),
  ],
  resolve: {
    modules: [filepath(srcDir), filepath(publicDir), filepath("node_modules")],
    extensions: [".js", ".mjs", ".elm", ".css", ".png"],
  },
  module: {
    rules: [
      {
        test: /\.(js|mjs)$/,
        exclude: [/node_modules/],
        use: {
          loader: "babel-loader",
        },
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: "url-loader",
          options: {
            limit: 10000,
            mimetype: "application/font-woff",
          },
        },
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "file-loader",
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "file-loader",
      },
    ],
  },
};

if (MODE === "development") {
  module.exports = merge(common, {
    module: {
      rules: [
        {
          test: /\.css$/,
          exclude: [/elm-stuff/],
          use: [
            "style-loader",
            {
              loader: "css-loader",
              options: {
                // 启用对 css 中资源的引用路径处理
                url: true,
              },
            },
            "postcss-loader",
          ],
        },
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            { loader: "elm-hot-webpack-loader" },
            {
              loader: "elm-webpack-loader",
              // https://github.com/elm-community/elm-webpack-loader
              options: {
                cwd: filepath("."),
                // add Elm's debug overlay to output
                debug: withDebug,
              },
            },
          ],
        },
      ],
    },
    devServer: {
      // 构建异常时不刷新整个页面
      hot: "only",
      historyApiFallback: true,
      // 静态文件目录不能包含代码，否则，修改代码会造成页面完全刷新
      static: {
        directory: filepath(publicDir, "assets"),
      },
    },
  });
}

if (MODE === "production") {
  module.exports = merge(common, {
    optimization: {
      minimizer: [
        // https://webpack.js.org/plugins/terser-webpack-plugin/
        new TerserPlugin({
          parallel: true,
        }),
        // https://www.npmjs.com/package/css-minimizer-webpack-plugin
        new CssMinimizerPlugin({
          parallel: true,
        }),
      ],
    },
    plugins: [
      // Delete everything from output-path (/dist) and report to user
      new CleanWebpackPlugin({
        root: filepath("."),
        exclude: [],
        verbose: true,
        dry: false,
      }),
      // Copy static assets
      new CopyWebpackPlugin({
        patterns: [
          {
            from: filepath(publicDir, "assets"),
          },
        ],
      }),
      new MiniCssExtractPlugin({
        // Options similar to the same options in webpackOptions.output
        // both options are optional
        filename: "[name]-[contenthash].css",
      }),
    ],
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: {
            loader: "elm-webpack-loader",
            // https://github.com/elm-community/elm-webpack-loader
            options: {
              cwd: filepath("."),
              optimize: true,
            },
          },
        },
        {
          test: /\.css$/,
          exclude: [/elm-stuff/],
          use: [
            MiniCssExtractPlugin.loader,
            {
              loader: "css-loader",
              options: {
                // 启用对 css 中资源的引用路径处理
                url: true,
              },
            },
            "postcss-loader",
          ],
        },
      ],
    },
  });
}
