const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue =  require('./loaders/vue')

environment.loaders.prepend('graphql', {
  test: /\.(graphql|gql)$/,
  loader: 'graphql-tag/loader'
})

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.append('vue', vue)
module.exports = environment
