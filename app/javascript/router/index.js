import Vue from 'vue'
import VueRouter from 'vue-router'
import _ from 'lodash'

import { deserializeSearch } from 'lib/util'

import CurricleAbout from 'views/About'
import CurricleExplore from 'views/Explore'
import CurricleFaq from 'views/Faq'
import CurricleHome from 'views/Home'
import CurriclePlan from 'views/Plan'
import CurricleTools from 'views/Tools'
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
    {
      path: '/about',
      component: CurricleAbout,
      meta: { title: 'About' }
    },
    { path: '/explore',
      component: CurricleExplore,
      children: [
        {
          path: '',
          component: ExploreIndex,
          default: true,
          meta: { title: 'Explore' }
        },
        {
          path: 'learning-styles',
          component: ExploreLearningStyles,
          meta: { title: 'Explore: Learning Styles' }
        },
        {
          path: 'instructor-networks',
          component: ExploreInstructorNetworks,
          meta: { title: 'Explore: Instructor Networks' }
        },
        {
          path: 'course-universe',
          component: ExploreCourseUniverse,
          meta: { title: 'Explore: Course Universe' }
        },
        {
          path: 'keyword-comparisons',
          component: ExploreKeywordComparisons,
          meta: { title: 'Explore: Keyword Comparisons' }
        }
      ]
    },
    {
      path: '/faq',
      component: CurricleFaq,
      meta: { title: 'FAQ' }
    },
    {
      path: '/home',
      component: CurricleHome
    },
    { path: '/plan',
      component: CurriclePlan,
      children: [
        {
          path: '',
          component: PlanWeekView,
          meta: { title: 'Plan by Week' }
        },
        {
          path: '/plan/week',
          component: PlanWeekView,
          meta: { title: 'Plan by Week' }
        },
        {
          path: '/plan/semester',
          component: PlanSemesterView,
          meta: { title: 'Plan by Semester' }
        },
        {
          path: '/plan/list',
          component: PlanListView,
          meta: { title: 'Plan as List' }
        }
      ]
    },
    {
      path: '/search',
      component: SearchBasic,
      meta: { title: 'Search' }
    },
    {
      path: '/search/advanced',
      component: SearchAdvanced,
      meta: { title: 'Advanced Search' }
    },
    {
      path: '/search/advanced/*',
      component: SearchAdvanced,
      props: deserializeSearch,
      meta: { title: 'Advanced Search' }
    },
    {
      path: '/shared-schedule/:scheduleToken',
      component: SharedSchedule,
      props: true,
      meta: { title: 'Shared Schedule' }
    },
    {
      path: '/tools',
      component: CurricleTools,
      meta: { title: 'Tools' }
    },
    {
      path: '*',
      redirect: 'home'
    }
  ]
})

router.beforeEach((to, _from, next) => {
  // Control anonymous access to specific pages
  const ANONYMOUS_PATHS = ['/home', '/about', '/faq']

  if (_.includes(ANONYMOUS_PATHS, to.path) || to.path.split('/')[1] === 'shared-schedule' || localStorage.getItem('curricle_api_token')) {
    next()
  } else {
    window.location = '/users/sign_in'
  }
})

router.afterEach((to, from) => {
  Vue.nextTick(() => {
    let title = 'Curricle'

    if (to.meta.title) { title += ` - ${to.meta.title}` }

    document.title = title
  })
})

export default router
