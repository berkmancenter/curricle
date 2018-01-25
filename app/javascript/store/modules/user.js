// Manipulation of user-related data

import axios from 'axios'
import _ from 'lodash'

const state = {
  courses: {},
  courseflags: {
    tray: {},
    schedule: {},
    annotated: {},
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

  courseIds (state) {
    var ids = {}

    _.forEach(state.courses.tray, x => { ids[x.external_course_id] = x.external_course_id })

    return ids
  },
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
  getCourses ({ commit }) {
    const courseUrl = '/courses/user_courses'
    axios
      .get(courseUrl)
      .then((response) => {
        commit('SET_COURSES', response.data)
        commit('SET_USER_SCHEDULE', response.data)
        commit('SET_USER_COURSE', response.data)
      })
  },
  selectCourse ({commit, dispatch}, course) {
    dispatch('app/hideTray', null, { root: true })
    if (typeof course !== 'object') {
      dispatch('lookupCourse', course).then(
        obj => {
          commit('SET_CURRENT_COURSE', obj)
        }
      )
    } else {
      commit('SET_CURRENT_COURSE', course)
    }
  },
  addToUserSchedule ({ commit, dispatch }, meetingId) {
    const addScheduleUrl = '/courses/add_to_schedule'
    axios
      .post(addScheduleUrl, {pattern_id: meetingId})
      .then((response) => {
        dispatch('getCourses')
      })
  },
  removeFromUserSchedule ({ commit, dispatch }, meetingId) {
    const removeScheduleUrl = '/courses/remove_from_schedule'
    axios
      .delete(removeScheduleUrl, {params: {pattern_id: meetingId}})
      .then((response) => {
        dispatch('getCourses')
      })
  },
  addRemoveUserSchedule ({ commit, dispatch, state }, meetingId) {
    if (state.userCoursesScheduleIds.includes(meetingId)) {
      dispatch('removeFromUserSchedule', meetingId)
    } else {
      dispatch('addToUserSchedule', meetingId)
    }
  },
  addCourseToUser ({ commit, dispatch, state }, courseId) {
    const addCourseUrl = '/courses/add_to_tray'
    axios
      .post(addCourseUrl, {id: courseId})
      .then((response) => {
        dispatch('getCourses')
      })
  },
  RemoveFromUserCourse ({ commit, dispatch, state }, courseId) {
    const removeCourseUrl = '/courses/remove_from_tray'
    axios
      .delete(removeCourseUrl, {id: courseId})
      .then((response) => {
        dispatch('getCourses')
      })
  },
  addRemoveUserCourse ({ commit, dispatch, state }, courseId) {
    if (state.userCourseIds.includes(courseId)) {
      dispatch('RemoveFromUserCourse', courseId)
    } else {
      dispatch('addCourseToUser', courseId)
    }
  },
  lookupCourse ({ state }, courseId) {
    if (state.courses && state.courses.tray) {
      var course = _.find(state.courses.tray, c => c.id === courseId)
      if (course) {
        return course
      }
    }
    return {}
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

  toggleCourseStatus ({ state, getters, dispatch }, { course, type }) {
    if (type && course) {
      state.courseflags[type][course] = !state.courseflags[type][course]
    }
  }
}

const mutations = {
  SET_COURSES: (state, value) => {
    state.courses = value
  },
  SET_USER_SCHEDULE: (state, value) => {
    state.userCoursesScheduleIds = value.tray
      .filter(item => !!item.user_schedule)
      .map(item => { return item.user_schedule[0].course_meeting_pattern_id })
  },
  SET_USER_COURSE: (state, value) => {
    state.userCourseIds = value.tray.map(item => { return item.id.toString() })
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
