import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import app from './modules/app.js'
import user from './modules/user.js'
import search from './modules/search.js'
import plan from './modules/plan.js'

Vue.use(Vuex)

const store = new Vuex.Store({
  modules: {
    app,
    user,
    search,
    plan,
  }
})

export default store;
