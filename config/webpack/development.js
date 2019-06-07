process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const eslintConfig = require('./development/eslint')
const vueImportConfig = require('./development/vue-import')

environment.config.merge(eslintConfig)
environment.config.merge(vueImportConfig)

module.exports = environment.toWebpackConfig()
