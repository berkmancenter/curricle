module.exports = {
  extends: [
    'standard',
    'plugin:vue/recommended'
  ],
  rules: {
    "no-debugger": 0, // TODO: Re-enable this rule after production launch
    "vue/component-name-in-template-casing": [
      "error",
      "kebab-case" // default is PascalCase but vue-router and bootstrap-vue currently require kebab-case
    ]
  }
}
