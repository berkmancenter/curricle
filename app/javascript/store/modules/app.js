// Manipulation of generic application state

const state = {
  viewmode: {
    tray: 'list-view',
    plan: 'list-view'
  },
  trayVisible: 0
}

const getters = {

}

const actions = {
  hideTray ({commit}) { commit('HIDE_TRAY') },
  selectView ({commit}, view) { commit('CHOOSE_SIDEBAR_VIEW', view) }
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
  TOGGLE_TRAY: state => { state.trayVisible = !state.trayVisible },
  SHOW_TRAY: state => { state.trayVisible = 1 },
  HIDE_TRAY: state => { state.trayVisible = 0 }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
