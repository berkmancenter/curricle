/*
  alias the Vue import to prevent multiple instances of Vue being loaded
  because we are using the compiler + runtime build in development
  https://bootstrap-vue.js.org/docs/#aliasing-vue-import
*/

module.exports = {
  resolve: {
    alias: {
      vue$: 'vue/dist/vue.esm.js'
    }
  }
}
