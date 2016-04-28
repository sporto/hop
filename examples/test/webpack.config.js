var path = require("path");

/*
publicPath is used for finding the bundles during dev
e.g. http://localhost:3000/bundles/app.js
When the index.html is served using the webpack server then just specify the path.
When index.html is served using a framework e.g. from Rails, Phoenix or Go
then you must specify the full url where the webpack dev server is running e.g. http://localhost:4000/bundles/
This path is also used for resolving relative assets e.g. fonts from css. So for production and staging this path has to be
overriden. See webpack.prod.config.js
*/
var publicPath = '/bundles/'

module.exports = {
  entry: {
    app: [
      './src/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
    publicPath:  publicPath,
  },

  module: {
    loaders: [
      {
        test: /\.(css|scss)$/,
        loaders: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&minetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
    ],

    noParse: /\.elm$/,
  },

};
