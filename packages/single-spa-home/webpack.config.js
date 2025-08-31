const webpackMerge = require("webpack-merge");
const singleSpaDefaults = require("webpack-config-single-spa-react");

module.exports = (webpackConfigEnv, argv) => {
  const defaultConfig = singleSpaDefaults({
    orgName: "mf-demo",
    projectName: "home",
    webpackConfigEnv,
    argv,
  });

  return webpackMerge(defaultConfig, {
    devtool: "source-map",
    module: {
      rules: [
        {
          test: /\.(js|ts|tsx)$/,
          exclude: /node_modules/,
          use: {
            loader: "babel-loader",
            options: {
              presets: [
                "@babel/preset-env",
                "@babel/preset-react",
                "@babel/preset-typescript"
              ]
            }
          }
        }
      ]
    },
    resolve: {
      extensions: [".js", ".jsx", ".ts", ".tsx"]
    }
  });
};
