// Manipulation of generic application state

const state = {
  alertText: '',
  semester: '',
  // TODO: make these detectable/generated from data?
  catalogYearStart: 1990,
  catalogYearEnd: 2020,
  selectedCourse: null,
  trayVisible: false
}

const getters = {
  currentCourse (state) {
    return state.selectedCourse
  }
}

const actions = {
  selectCourse ({ commit, getters }, course) {
    commit('SET_SELECTED_COURSE', course)
  },
  trayClose ({ commit }) {
    commit('SET_TRAY_VISIBILITY', false)
  },
  trayToggle ({ commit, state }) {
    commit('SET_TRAY_VISIBILITY', !state.trayVisible)
  }
}

const mutations = {
  SET_SEMESTER: (state, s) => {
    state.semester = s
  },
  SET_ALERT_TEXT: (state, text) => {
    state.alertText = text
  },
  SET_SELECTED_COURSE: (state, course) => {
    state.selectedCourse = course
  },
  CLEAR_SELECTED_COURSE: (state) => {
    state.selectedCourse = null
  },
  SET_TRAY_VISIBILITY: (state, value) => {
    state.trayVisible = value
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
