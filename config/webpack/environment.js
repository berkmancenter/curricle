const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue =  require('./loaders/vue')

environment.loaders.prepend('graphql', {
  test: /\.(graphql|gql)$/,
  exclude: /node_modules/,
  loader: 'graphql-tag/loader'
})

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
