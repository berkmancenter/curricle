const environment = require('./environment')
const eslintConfig = require('./development/eslint')

environment.config.merge(eslintConfig)

module.exports = environment.toWebpackConfig()
