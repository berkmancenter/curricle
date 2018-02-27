import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import { deserializeSearch } from 'lib/util'

import CurricleExplore from '../views/explore'
import CurriclePlan from '../views/plan'
import CurricleSearch from '../views/search'
import SharedSchedule from '../views/SharedSchedule'

Vue.use(VueRouter)

export default new VueRouter({
  routes: [
    { path: '/explore', component: CurricleExplore },
    { path: '/plan', component: CurriclePlan },
    { path: '/search', component: CurricleSearch },
    { path: '/search/*', component: CurricleSearch, props: deserializeSearch },
    { path: '/shared-schedule/:scheduleToken', component: SharedSchedule, props: true },
    { path: '*', redirect: 'search' }
  ]
})
