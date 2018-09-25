const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

environment.loaders.prepend('graphql', {
  test: /\.(graphql|gql)$/,
  loader: 'graphql-tag/loader'
})

environment.loaders.append('vue', vue)
module.exports = environment
