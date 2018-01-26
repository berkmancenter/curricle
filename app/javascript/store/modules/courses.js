// Manipulation of non-course-related course-specific data

import Vue from 'vue/dist/vue.esm'
import _ from 'lodash'

/*
 * This basic idea behind this module is to provide a location to
 * store full course data for all courses we've seen in a consistent
 * format; this is a registry of sorts.  Subsequent modules can use
 * routines to resolve/gather sets of courses that match specific ids.
 */

const state = {
  courses: {}
}

const getters = {
}

const actions = {
  /*
   * Register an array of objects as courses in the registry, indexed
   * off of their id.  (This will probably be from the search for the
   * most part.)
   */
  registerCourses ({ commit }, courses) {
    commit('ADD_COURSES', courses)
  },

  /*
   * Lookup course information given a list of course ids and populate
   * in the registry.  Will replace anything in the existing registry.
   */
  lookupCourses ({ commit, dispatch }, courses) {
    if (courses && courses.length) {
      dispatch('search/runSearch', { ids: courses,
        handler:
        response => {
          commit('ADD_COURSES', response.data.courses)
          dispatch('getCourses', courses)
        }
      },
      { root: true }
      )
    }
  },

  /*
   * Return an object of course objects from the registry given a list
   * of course ids, looking up as required for any missing objects
   * Call the corresponding action with found data
   */

  resolveCourses ({ dispatch, state }, courses) {
    // find the missing ids, add 'em and return the results
    var missing = _.difference(courses, _.keys(state.courses))
    var present = _.difference(courses, missing)

    if (missing && missing.length) {
      dispatch('lookupCourses', missing)
    }
    if (present && present.length) {
      dispatch('getCourses', present)
    }
  },

  /*
   * Retrieves a list of courses from the course cache and commits to the user's state.
   * Skips missing.
   */

  getCourses ({ state, dispatch }, courses) {
    var obj = {}

    _.each(courses, course => {
      if (state.courses[course]) {
        obj[course] = state.courses[course]
      }
    })

    dispatch('user/appendCourses', obj, { root: true })
  },

  /*
   * Return information from a single course by id from the registry
   */
  getCourseById ({ state }, course) {
    return state.courses[course]
  }

}

const mutations = {
  ADD_COURSES: (state, courses) => {
    _.each(courses, course => {
      Vue.set(state.courses, course.id, course)
    })
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
