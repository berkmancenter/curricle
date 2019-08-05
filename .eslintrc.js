module.exports = {
  root: true,
  env: {
    node: true
  },
  'extends': [
    'plugin:vue/recommended',
    'standard'
  ],
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'vue/component-name-in-template-casing': [
      'error',
      'kebab-case' // default is PascalCase but vue-router and bootstrap-vue currently require kebab-case
    ],
    'vue/multiline-html-element-content-newline': [
      'error',
      {
        'ignores': ['a', 'router-link'] // Enforcement of this rule can introduce unwanted trailing whitepace in link tags
      }
    ]
  }
}
