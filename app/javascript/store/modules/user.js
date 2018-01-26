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
  },

  // placeholder for selected course; TODO: move to app
  currentCourse: {}
}

const getters = {
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
  getUserData ({ commit, dispatch }) {
    const courseUrl = '/courses/user_courses'
    var ids = []

    axios
      .get(courseUrl)
      .then((response) => {
        _.each(
          response.data.tray,
          t => {
            ids.push(t.id)

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

        if (ids.length) {
          // now actually update the courses
          dispatch('courses/resolveCourses', ids, { root: true })
        }
      })
  },

  /* appends an object mapping of course ids to course objects to the local course cache. */
  appendCourses ({ commit }, obj) {
    commit('APPEND_COURSES', obj)
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
      var removing, origState

      removing = origState = !!state.courseflags[type][course]

      if (['tray', 'schedule'].includes(type)) {
        // optimistic setting for ideal UI responsiveness
        commit('SET_USER_FLAG', { type, course, value: !origState })

        var url = '/courses/' + (removing ? 'remove_from_' : 'add_to_') + type
        var promise = removing ? axios.delete(url, { params: { id: course } }) : axios.post(url, { id: course })

        // all handlers are the same, basically optimize for success case and set back if we need to...
        promise.then(
          // success case: notify success?
          () => {},
          // failure case: rollback optimistic change
          () => {
            commit('SET_USER_FLAG', { type, course, value: origState })
          }
        )
      } else {
        commit('SET_USER_FLAG', { type, course, value: !origState })
      }
    }
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
