import Vue from 'vue'
import Vuex from 'vuex'
import app from './modules/app.js'
import user from './modules/user.js'
import search from './modules/search.js'
import plan from './modules/plan.js'
import courses from './modules/courses.js'

Vue.use(Vuex)

const store = new Vuex.Store({
  modules: {
    app,
    user,
    search,
    plan,
    courses
  }
})

export default store
