const { environment } = require('@rails/webpacker')

environment.loaders.prepend('graphql', {
  test: /\.(graphql|gql)$/,
  loader: 'graphql-tag/loader'
})

module.exports = environment
