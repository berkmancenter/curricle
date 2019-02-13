// Manipulation of generic application state

import _ from 'lodash'

const state = {
  alertText: '',
  viewmode: {
    tray: 'list-view',
    plan: 'list-view'
  },
  semester: '',
  // TODO: make these detectable/generated from data?
  catalogYearStart: 1990,
  catalogYearEnd: 2020,
  selectedCourse: null,
  sidebarStack: []
}

const getters = {
  sidebarCurrentType (state) {
    return state.sidebarStack.length && state.sidebarStack[0][0]
  },
  sidebarCurrentContext (state) {
    return state.sidebarStack.length && state.sidebarStack[0][1]
  },
  currentCourse (state) {
    return state.selectedCourse
  },
  isTrayVisible (state, getters) {
    return getters.sidebarCurrentType === 'tray'
  }
}

const actions = {
  trayToggle ({ commit, getters, state }) {
    var wasVis = getters.isTrayVisible
    commit('REMOVE_SIDEBAR_ELEM', { type: 'tray' })
    if (!wasVis) {
      commit('ADD_SIDEBAR_ELEM', { type: 'tray' })
    }
  },
  selectView ({ commit }, view) { commit('CHOOSE_SIDEBAR_VIEW', view) },
  selectCourse ({ commit, getters }, course) {
    commit('SET_SELECTED_COURSE', course)
  },
  closeSidebar ({ commit, state }) {
    for (let i = 0; i <= state.sidebarStack.length; i++) {
      commit('REMOVE_TOP_SIDEBAR_ELEM')
    }
  }
}

const mutations = {
  CHOOSE_SIDEBAR_VIEW: (state, obj) => {
    if (typeof obj === 'object') {
      var { type, view } = obj
      if (['semester', 'multi-year', 'list-view'].includes(view)) {
        state.viewmode[type] = view
      }
    }
  },
  REMOVE_TOP_SIDEBAR_ELEM: (state) => {
    if (state.sidebarStack.length) {
      state.sidebarStack = _.drop(state.sidebarStack)
    }
  },
  REMOVE_SIDEBAR_ELEM: (state, { type, payload }) => {
    // might want to use payload to limit removal in the future
    var idx = _.findIndex(state.sidebarStack, e => e[0] === type)
    if (idx !== -1) {
      state.sidebarStack.splice(idx, 1)
    }
  },
  ADD_SIDEBAR_ELEM: (state, { type, payload }) => {
    // prepends the matching element and includes the payload as an optional second context param
    state.sidebarStack.unshift([type, payload])
  },
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
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
