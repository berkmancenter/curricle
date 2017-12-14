import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import CurricleExplore from '../views/explore'
import CurriclePlan from '../views/plan'
import CurricleSearch from '../views/search'

Vue.use(VueRouter)

export default new VueRouter({
  routes: [
    { path: '/explore', component: CurricleExplore },
    { path: '/plan', component: CurriclePlan },
    { path: '/search', component: CurricleSearch },
    { path: '*', redirect: 'search' }
  ]
})
