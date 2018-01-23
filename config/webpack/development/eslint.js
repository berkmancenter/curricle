module.exports = {
  module: {
    rules: [
      {
        test: /\.(js|vue)$/,
        exclude: /node_nodules/,
        enforce: 'pre',
        loader: 'eslint-loader',
        options: {
          emitError: true,
          emitWarning: true,
          failOnError: true,
          failOnWarning: true
        }
      }
    ]
  }
}
