import Vue from 'vue'
import Vuex from 'vuex'
import user from './modules/user'
import search from './modules/search'
import plan from './modules/plan'

Vue.use(Vuex)

const store = new Vuex.Store({
  modules: {
    user,
    search,
    plan,
  }
})

export default { store };
