// Manipulation of plan-related data

import Vue from 'vue/dist/vue.esm'
import _ from 'lodash'
import { sortedSemesters } from 'lib/util'

const state = {
  semester: '',
  filters: {},
  filterFieldMap: {
    department: 'academic_group_description',
    semester: 'semester'
  }
}

const getters = {
  filteredCourses (state, getters) {
    // per lodash docs, empty object is true for all
    return _.filter(getters.trayCourses, _.mapKeys(state.filters, (v, k) => {
      return state.filterFieldMap[k] || k
    }))
  },
  // this is to import the vuex user.trayCourses and use locally as dependent
  trayCourses (state, getters, rootState, rootGetters) {
    return rootGetters['user/trayCourses']
  },
  departmentsInTray (state, getters) {
    return _.uniq(getters.trayCourses.map(k => k.academic_group_description).sort())
  },
  semestersInTray (state, getters) {
    return _.uniq(getters.trayCourses.map(k => k.semester).sort())
  },
  // returns all courses which are currently scheduled in the tray ()
  scheduledCourses (state, getters, rootState, rootGetters) {
    return rootGetters['user/scheduledCourses']
  },
  scheduledCoursesBySemester (state, getters) {
    return _.groupBy(getters.scheduledCourses, 'semester')
  },
  trayCoursesBySemester (state, getters) {
    return _.groupBy(getters.trayCourses, 'semester')
  },
  sortedSemestersInSchedule (state, getters) {
    return sortedSemesters(_.keys(getters.scheduledCoursesBySemester))
  },
  sortedSemestersInTray (state, getters) {
    return sortedSemesters(getters.semestersInTray)
  }
}

const actions = {
  setFilter ({commit}, filter) {
    commit('SET_FILTER', filter)
  },
  setSemester ({commit}, semester) {
    commit('SET_SEMESTER', semester)
  }
}

const mutations = {
  SET_FILTER (state, {name, value}) {
    if (value) {
      Vue.set(state.filters, name, value)
    } else {
      Vue.delete(state.filters, name)
    }
  },
  SET_SEMESTER (state, semester) {
    state.semester = semester
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
