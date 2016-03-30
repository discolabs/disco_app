var webpack = require('webpack');
var path = require('path');

var babelLoader = {
  test: /\.jsx?$/,
  exclude: /(node_modules|bower_components)/,
  loader: 'babel',
  query: {
    presets: ['react', 'es2015'],
    env: {
      "development": {
        "plugins": [["react-transform", {
          "transforms": [{
            "transform": "react-transform-hmr",
            // if you use React Native, pass "react-native" instead:
            "imports": ["react"],
            // this is important for Webpack HMR:
            "locals": ["module"]
          }]
        }]]
      }
    }
  }
};

var sassLoader = {
  test: /\.scss$/,
  loaders: ['style', 'css', 'sass']
};

module.exports = {
  entry: './examples/app.js',
  output: {
    path: path.resolve(__dirname, 'dist/'),
    publicPath: 'http://localhost:8080/assets',
    filename: 'bundle.js'
  },
  resolve: {
    alias: {
      components: path.resolve(__dirname, 'src/components')
    },
    extensions: ['', '.js', '.jsx']
  },
  module: {
    loaders: [babelLoader, sassLoader],
    plugins: [
      new webpack.NoErrorsPlugin()
    ],
    devtool: 'eval'
  }
};
