// Manipulation of user-related data

import _ from 'lodash'
import Vue from 'vue/dist/vue.esm'
import apolloClient from 'apollo'
import USER_COURSES_QUERY from '../../graphql/UserCourses.gql'

/*
 * Represent user-specific data; courses are ids for the most part,
 * but are resolved to objects in the getters.
 */

const state = {
  apiToken: '',
  scheduleToken: '',
  sharedScheduleToken: '',

  // holds canonical courses in tray
  courses: {},

  // local state of courses
  courseflags: {
    // id -> bool; keys with true values are in the tray; can exists with false ones
    tray: {},
    // id -> bool; keys with true values are in the schedule; can exist with false ones
    schedule: {},
    // id -> ['list', 'of', 'annotations']; empty if not annotated
    annotated: {},
    // id ->
    tagged: {}
  }
}

const getters = {
  courseIdInSchedule: (state, getters) => (courseId) => {
    return getters.userCoursesScheduleIds.includes(courseId)
  },
  courseIdInTray: (state, getters) => (courseId) => {
    return getters.userCourseIds.includes(courseId)
  },
  // computed trayCourses
  trayCourses (state) {
    var ids = _.filter(
      _.keys(state.courseflags.tray),
      k => state.courseflags.tray[k]
    )
    var courses = ids.map(i => state.courses[i]) || []
    return courses.filter(e => !_.isUndefined(e))
  },

  scheduledCourses (state) {
    var ids = _.filter(
      _.keys(state.courseflags.schedule),
      k => state.courseflags.schedule[k]
    )
    var courses = ids.map(i => state.courses[i]) || []
    return courses.filter(e => !_.isUndefined(e))
  },

  // return a list of course ids in the tray
  userCourseIds (state) {
    return _.filter(
      _.keys(state.courseflags.tray),
      k => state.courseflags.tray[k]
    )
  },

  // return a list of course ids in the schedule
  userCoursesScheduleIds (state) {
    return _.filter(
      _.keys(state.courseflags.schedule),
      k => state.courseflags.schedule[k]
    )
  },
  userAuthenticated (state) {
    return Boolean(state.apiToken)
  },
  courseIdStyles: (state, getters) => (courseId) => {
    if (getters.courseIdInSchedule(courseId)) {
      return 'schedule-course'
    } else {
      if (getters.courseIdInTray(courseId)) {
        return 'tray-course'
      }
    }

    return ''
  }
}

const actions = {
  getCourses (context) {
    console.error("Don't use this entry point any more (change caller!)")
  },

  getUserData ({ commit, state, dispatch }) {
    commit('SET_API_TOKEN')
    commit('SET_SCHEDULE_TOKEN')

    if (!state.apiToken && !state.sharedScheduleToken) {
      return
    }

    apolloClient.query({
      query: USER_COURSES_QUERY,
      variables: { scheduleToken: state.sharedScheduleToken }
    }).then(response => {
      const userCourses = response.data.user_courses

      if (userCourses.length) {
        _.each(
          userCourses,
          course => {
            commit('SET_USER_FLAG', { type: 'tray', course: course.id, value: true })

            if (course.annotation) {
              commit('SET_USER_FLAG', { type: 'annotated', course: course.id, value: true })
            }

            if (course.user_course.include_in_path) {
              commit('SET_USER_FLAG', { type: 'schedule', course: course.id, value: true })
            }
          }
        )
        // now actually update the courses
        dispatch('courses/resolveCourses', _.map(userCourses, 'id'), { root: true })
      }
    })
  },

  /* appends an object mapping of course ids to course objects to the local course cache. */
  appendCourses ({ commit }, obj) {
    commit('APPEND_COURSES', obj)
  },

  /*
   * courseHasStatus checks a given course id and returns true if the
   * state type is true for the user in question.  This is related to
   * the CourseAction component, so consolidating any checks here.

   * If you need to add more types you will need to add the checker
   * here and adjust the CourseAction component as well to add the
   * icons/actions used.
   */
  courseHasStatus ({ state, getters }, { course, type }) {
    if (type === 'shareable') {
      return true
    }

    return state.courseflags[type][course]
  },

  toggleCourseStatus ({ state, commit, dispatch }, { course, type }) {
    if (type && course) {
      var origState = !!state.courseflags[type][course]

      commit('SET_USER_FLAG', { type, course, value: !origState })

      if (type === 'tray' && origState === false) {
        commit('SET_USER_FLAG', { type: 'schedule', course, value: true })
      }

      if (type === 'tray' && origState === true) {
        commit('SET_USER_FLAG', { type: 'schedule', course, value: false })
      }

      if (type === 'schedule' && origState === false) {
        commit('SET_USER_FLAG', { type: 'tray', course, value: true })
      }
    }
  },

  clearTokens ({ commit }) {
    commit('CLEAR_API_TOKEN')
    commit('CLEAR_SCHEDULE_TOKEN')
  }
}

const mutations = {
  APPEND_COURSES: (state, obj) => {
    _.each(obj, (course, id) => Vue.set(state.courses, id, course))
  },
  SET_USER_FLAG: (state, { type, course, value }) => {
    // required due to reactivity requirements
    Vue.set(state.courseflags[type], course, value)
  },
  SET_API_TOKEN (state) {
    state.apiToken = localStorage.getItem('curricle_api_token')
  },
  CLEAR_API_TOKEN (state) {
    localStorage.removeItem('curricle_api_token')
    state.apiToken = null
  },
  SET_SCHEDULE_TOKEN (state) {
    state.scheduleToken = localStorage.getItem('curricle_schedule_token')
  },
  SET_SHARED_SCHEDULE_TOKEN (state, token) {
    state.sharedScheduleToken = token
  },
  CLEAR_SCHEDULE_TOKEN (state) {
    localStorage.removeItem('curricle_schedule_token')
    state.scheduleToken = null
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
