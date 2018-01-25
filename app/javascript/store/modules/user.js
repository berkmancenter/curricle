// Manipulation of user-related data

import axios from 'axios'
import _ from 'lodash'
import Vue from 'vue/dist/vue.esm'

/*
 * Represent user-specific data; courses are ids for the most part,
 * but are resolved to objects in the getters.
 */

const state = {
  // holds canonical courses in tray
  courses: [],

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
  },

  // placeholder for selected course; TODO: move to app
  currentCourse: {}
}

const getters = {
  // computed trayCourses
  trayCourses (state) {
    return state.courses
  },

  // NOTE: candidate for removal
  courseIds (state) {
    var ids = {}

    _.forEach(state.courses.tray, x => { ids[x.external_course_id] = x.external_course_id })

    return ids
  },

  // NOTE: candidate for removal
  coursesByDate (state) {
    var filter = state.filter
    var events = {}

    if ((filter !== undefined) && (Object.keys(filter).length > 0)) {
      const semester = filter.value.split(' ')
      _.forEach(state.courses.semester, (day, key) => {
        events[key] = day.filter((item) => {
          if (filter.name === 'term_name') {
            return item.term_name === semester[0] && item.term_year === semester[1]
          } else {
            return item[filter.name] === filter.value
          }
        })
      })
    } else {
      events = state.courses.semester
    }
    return events
  },

  // NOTE: candidate for removal
  coursesByYear (state) {
    var filter = state.filter
    var yearlyEvents

    if ((filter !== undefined) && (Object.keys(filter).length > 0)) {
      yearlyEvents = {}
      const semester = filter.value.split(' ')
      _.forEach(state.courses.multi_year, (day, key) => {
        yearlyEvents[key] = day.filter((item) => {
          if (filter.name === 'term_name') {
            return item.term_name === semester[0] && item.term_year === semester[1]
          } else {
            return item[filter.name] === filter.value
          }
        })
      })
    } else {
      yearlyEvents = state.courses.multi_year
    }
    return yearlyEvents
  },

  // return true if we have a selected course
  // TODO: convert to using internal course id instead of an object
  validCourseSelected (state) {
    return state.currentCourse && state.currentCourse.id
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
  }
}

const actions = {
  getCourses (context) {
    console.error("Don't use this entry point any more (change caller!)")
  },

  /* Here we do a fresh state reset and pull user's information from
   * API.  We are converting inefficiently here because we will be
   * using a new GraphQL endpoint which will just return this specific
   * data in the format we're converting to here, so making everything
   * work relative to this new data format.
   */
  getUserData ({ commit }) {
    const courseUrl = '/courses/user_courses'
    axios
      .get(courseUrl)
      .then((response) => {
        _.each(
          response.data.tray,
          t => {
            commit('SET_USER_FLAG', { type: 'tray', course: t.id, value: true })
            if (t.user_schedule && t.user_schedule.length && t.user_schedule[0].include_in_path) {
              commit('SET_USER_FLAG', { type: 'schedule', course: t.id, value: true })
            }
            if (t.user_annotations && t.user_annotations.length) {
              commit('SET_USER_FLAG', { type: 'annotated', course: t.id, value: t.user_annotations })
            }
            if (t.user_tags && t.user_tags.length) {
              commit('SET_USER_FLAG', { type: 'tagged', course: t.id, value: t.user_tags })
            }
          }
        )
      })
  },

  /* Populate the tray with the contents of the course lists */
  refreshCourses ({ commit, dispatch, getters }) {
    // this assumes that everything in the schedule is also in the
    // tray; that might be an incorrect assumption; if not, build a
    // list of all non-false keys in either tray *or* schedule so
    // these are all represented here

    dispatch(
      'courses/resolveCourses',
      getters.userCourseIds
    ).then(res => commit('SET_COURSES', res))
  },

  /* Select a course so we can see on the sidebar */
  selectCourse ({commit, dispatch}, course) {
    dispatch('app/hideTray', null, { root: true })
    if (typeof course !== 'object') {
      dispatch('courses/getCourseById', course, { root: true }).then(
        obj => {
          commit('SET_CURRENT_COURSE', obj)
        }
      )
    } else {
      commit('SET_CURRENT_COURSE', course)
    }
  },

  addToUserSchedule ({ commit, dispatch }, id) {
    const addScheduleUrl = '/courses/add_to_schedule'
    axios
      .post(addScheduleUrl, { id })
      .then((response) => {
        commit('SET_USER_FLAG', { type: 'schedule', value: true, course: id })
      })
  },
  removeFromUserSchedule ({ commit, dispatch }, id) {
    const removeScheduleUrl = '/courses/remove_from_schedule'
    axios
      .delete(removeScheduleUrl, { params: { id } })
      .then((response) => {
        commit('SET_USER_FLAG', { type: 'schedule', value: false, course: id })
      })
  },
  addRemoveUserSchedule ({ commit, dispatch, getters }, id) {
    if (getters.userCoursesScheduleIds.includes(id)) {
      dispatch('removeFromUserSchedule', id)
    } else {
      dispatch('addToUserSchedule', id)
    }
  },
  addCourseToUser ({ commit, dispatch }, id) {
    const addCourseUrl = '/courses/add_to_tray'
    axios
      .post(addCourseUrl, {id})
      .then((response) => {
        commit('SET_USER_FLAG', { type: 'tray', value: true, course: id })
      })
  },
  removeFromUserCourse ({ commit, dispatch }, id) {
    const removeCourseUrl = '/courses/remove_from_tray'
    axios
      .delete(removeCourseUrl, { params: {id} })
      .then((response) => {
        commit('SET_USER_FLAG', { type: 'tray', value: false, course: id })
      })
  },
  addRemoveUserCourse ({ commit, dispatch, getters }, id) {
    if (getters.userCourseIds.includes(id)) {
      dispatch('removeFromUserCourse', id)
    } else {
      dispatch('addCourseToUser', id)
    }
  },

  /*
   * courseHasStatus checks a given course id and returns true if the
   * state type is true for the user in question.  This is related to
   * the course-action component, so consolidating any checks here.

   * If you need to add more types you will need to add the checker
   * here and adjust the course-action component as well to add the
   * icons/actions used.
   */
  courseHasStatus ({ state, getters }, { course, type }) {
    if (type === 'shareable') {
      return true
    }

    return state.courseflags[type][course]
  },

  /*
   * toggleCourseStatus does whatever is needed (web requests, etc) in
   * order to change the status of the course information.  In all
   * likelihood this will dispatch to other actions/handlers.
   */

  toggleCourseStatus ({ state, commit, dispatch }, { course, type }) {
    if (type && course) {
      var act

      if (type === 'tray') {
        act = 'addRemoveUserCourse'
      }
      if (type === 'schedule') {
        act = 'addRemoveUserSchedule'
      }

      if (act) {
        dispatch(act, course)
      } else {
        commit('SET_USER_FLAG', { type, course, value: !state.courseflags[type][course] })
      }
    }
  }
}

const mutations = {
  SET_COURSES: (state, value) => {
    state.courses = value
  },
  SET_USER_FLAG: (state, { type, course, value }) => {
    // required due to reactivity requirements
    Vue.set(state.courseflags[type], course, value)
  },
  SET_CURRENT_COURSE: (state, value) => {
    state.currentCourse = value
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
