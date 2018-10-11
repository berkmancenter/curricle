// Manipulation of plan-related data

import Vue from 'vue/dist/vue.esm'
import _ from 'lodash'
import { sortedSemesters } from 'lib/util'

const state = {
  semester: '',
  filters: {},
  filterFieldMap: {
    department: 'class_academic_org_description',
    semester: 'semester'
  },
  provisionalCourses: {}
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
    return _.uniq(getters.trayCourses.map(k => k.class_academic_org_description).sort())
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
  },
  addProvisionalCourse ({commit}, course) {
    commit('ADD_PROVISIONAL_COURSE', course)
  },
  removeProvisionalCourse ({commit}, course) {
    commit('DEL_PROVISIONAL_COURSE', course)
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
  },
  ADD_PROVISIONAL_COURSE (state, course) {
    if (course && course.id) {
      Vue.set(state.provisionalCourses, course.id, course)
    }
  },
  DEL_PROVISIONAL_COURSE (state, course) {
    if (course && course.id) {
      Vue.delete(state.provisionalCourses, course.id)
    }
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
