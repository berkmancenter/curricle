/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue'
import router from '../router'
import store from '../store'
import apolloClient from 'apollo'
import VueApollo from 'vue-apollo'
import BootstrapVue from 'bootstrap-vue'
import { library } from '@fortawesome/fontawesome-svg-core'
import { far } from '@fortawesome/free-regular-svg-icons'
import { fas } from '@fortawesome/free-solid-svg-icons'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import App from '../app'
import VueMatomo from 'vue-matomo'

library.add(far, fas)

Vue.use(BootstrapVue)
Vue.use(VueApollo)
Vue.use(VueMatomo, {
  host: 'https://stats.berkman.harvard.edu',
  siteId: 8,
  router: router
})

const apolloProvider = new VueApollo({
  defaultClient: apolloClient
})

document.addEventListener('DOMContentLoaded', () => {
  /* eslint-disable no-new */
  new Vue({
    el: '#app',
    router,
    store,
    apolloProvider,
    render: h => h(App)
  })
})
