// Manipulation of user-related data

import axios from 'axios'
import _ from 'lodash'

const state = {
  courses: {},
  filter: {},
  userCoursesScheduleIds: [],
  currentCourse: {},
  userCourseIds: []
}

const getters = {
  trayCourses (state) {
    return state.courses.tray
  },
  courseIds (state) {
    var ids = {}

    _.forEach(state.courses.tray, x => ids[x.external_course_id] = x.external_course_id)

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
      _.forEach(courses.multi_year, (day, key) => {
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
      .delete('/courses/remove_from_tray', {params: {id: courseId} })
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
