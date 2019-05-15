import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import { deserializeSearch } from 'lib/util'

import CurricleAbout from '../views/About'
import CurricleExplore from '../views/explore'
import CurricleHome from '../views/Home'
import CurriclePlan from 'views/Plan'
import SearchAdvanced from 'views/SearchAdvanced'
import SearchBasic from 'views/SearchBasic'
import SharedSchedule from '../views/SharedSchedule'
import ExploreIndex from '../components/explore/index'
import ExploreClasses from '../components/explore/classes'
import ExploreInstructors from '../components/explore/instructors'
import ExploreKeywords from '../components/explore/keywords'
import ExploreUniverse from '../components/explore/universe'
import PlanListView from 'components/plan/ListView'
import PlanWeekView from 'components/plan/WeekView'
import PlanSemesterView from 'components/plan/SemesterView'

Vue.use(VueRouter)

const router = new VueRouter({
  routes: [
    { path: '/about', component: CurricleAbout },
    { path: '/explore',
      component: CurricleExplore,
      children: [{
        path: '',
        component: ExploreIndex,
        default: true
      }, {
        path: 'classes',
        component: ExploreClasses
      }, {
        path: 'instructor',
        component: ExploreInstructors
      }, {
        path: 'keywords',
        component: ExploreKeywords
      }, {
        path: 'universe',
        component: ExploreUniverse
      }]
    },
    { path: '/home', component: CurricleHome },
    { path: '/plan',
      component: CurriclePlan,
      children: [
        { path: '', component: PlanListView },
        { path: '/plan/list', component: PlanListView },
        { path: '/plan/week', component: PlanWeekView },
        { path: '/plan/semester', component: PlanSemesterView }
      ]
    },
    { path: '/search', component: SearchBasic },
    { path: '/search/advanced', component: SearchAdvanced },
    { path: '/search/advanced/*', component: SearchAdvanced, props: deserializeSearch },
    { path: '/shared-schedule/:scheduleToken', component: SharedSchedule, props: true },
    { path: '*', redirect: 'home' }
  ]
})

// Prevent anonymous access to any route other than the landing page
router.beforeEach((to, _from, next) => {
  if (to.path === '/home' || localStorage.getItem('curricle_api_token')) {
    next()
  } else {
    window.location = '/users/sign_in'
  }
})

export default router
