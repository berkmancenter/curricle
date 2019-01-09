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
    ],
    "vue/multiline-html-element-content-newline": [
      "error",
      {
        "ignores": ["a"] // Enforcement of this rule can introduce unwanted trailing whitepace in link tags
      }
    ]
  }
}
