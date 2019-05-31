import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import { deserializeSearch } from 'lib/util'

import CurricleAbout from '../views/About'
import CurricleExplore from 'views/Explore'
import CurricleHome from '../views/Home'
import CurriclePlan from 'views/Plan'
import SearchAdvanced from 'views/SearchAdvanced'
import SearchBasic from 'views/SearchBasic'
import SharedSchedule from '../views/SharedSchedule'
import ExploreIndex from 'components/explore/Index'
import ExploreLearningStyles from 'components/explore/LearningStyles'
import ExploreInstructorNetworks from 'components/explore/InstructorNetworks'
import ExploreCourseUniverse from 'components/explore/CourseUniverse'
import ExploreKeywordComparisons from 'components/explore/KeywordComparisons'
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
        path: 'learning-styles',
        component: ExploreLearningStyles
      }, {
        path: 'instructor-networks',
        component: ExploreInstructorNetworks
      }, {
        path: 'course-universe',
        component: ExploreCourseUniverse
      }, {
        path: 'keyword-comparisons',
        component: ExploreKeywordComparisons
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
