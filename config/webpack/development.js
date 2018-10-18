process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const eslintConfig = require('./development/eslint')

environment.config.merge(eslintConfig)

module.exports = environment.toWebpackConfig()
