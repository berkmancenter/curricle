// Manipulation of generic application state

const state = {
  viewmode: 'list-view',
  trayVisible: 0
}

const getters = {

}

const actions = {

}

const mutations = {
  CHOOSE_SIDEBAR_VIEW: (state, view) => {
    if (['semester', 'multi-year', 'list-view'].includes(view)) {
      state.viewmode = view
    }
  },
  TOGGLE_TRAY: state => state.trayVisible = !state.trayVisible,
  SHOW_TRAY: state => state.trayVisible = 1,
  HIDE_TRAY: state => state.trayVisible = 0
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
