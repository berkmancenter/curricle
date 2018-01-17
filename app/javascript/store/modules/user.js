// Manipulation of user-related data

import axios from 'axios'
import _ from 'lodash'

const state = {
  courses: {},
  filter: {},
}

const getters = {
  trayCourses (state) {
    return state.courses.tray
  },
  courseIds (state) {
    var ids = {}

    _.forEach(state.courses.tray,x => ids[x.external_course_id] = x.external_course_id)

    return ids
  },
  coursesByDate (state) {
    var filter = state.filter
    var events = {}

    if ((filter != undefined) && (Object.keys(filter).length > 0)) {
      const semester = filter.value.split(" ")
      _.forEach(state.courses.semester, (day, key) => {
        events[key] = day.filter((item) => {
          if (filter.name === 'term_name'){
            return item.term_name ==  semester[0] && item.term_year == semester[1]
          }
          else{
            return item[filter.name] == filter.value
          }
        })
      })
    }
    else {
      events = state.courses.semester
    }
    return events
  },
  coursesByYear (state) {
    var filter = state.filter
    var yearlyEvents

    if ((filter != undefined) && (Object.keys(filter).length > 0)) {
      yearlyEvents = {};
      const semester = filter.value.split(" ")
      _.forEach(courses.multi_year, (day, key) => {
        yearlyEvents[key] = day.filter((item) => {
          if (filter.name === 'term_name'){
            return item.term_name ==  semester[0] && item.term_year == semester[1]
          }
          else {
            return item[filter.name] == filter.value
          }
        })
      })
    }
    else{
      yearlyEvents = state.courses.multi_year
    }
  }
}

const actions = {
  getCourses ({ commit }) {
      const course_url = '/courses/user_courses'
      axios
      .get(course_url)
      .then((response) => {
        commit('SET_COURSES', response.data)
      })
  },
}

const mutations = {
  SET_COURSES: (state, value) => {
    state.courses = value
  },
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
