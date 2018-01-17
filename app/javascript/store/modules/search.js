// Manipulation of search-related data

import _ from 'lodash'

const state = {
  // list of objects with { text, weight, applyTo, active }
  keywords: [],
  results: []
}

const getters = {
  activeKeywords: state => state.keywords.filter(kw => kw.active),
  inactiveKeywords: state => state.keywords.filter(kw => !kw.active)
}

const actions = {
  addKeyword ({commit}, keyword) {
    commit('ADD_KEYWORD', keyword)
  },
  deactivateKeyword ({commit, state}, keyword) {
    var idx = _.findIndex(state.keywords, k => k.text == keyword.text)
    if (idx != -1) {
      commit('DEACTIVATE_KEYWORD', idx)
    }
  },
  activateKeyword ({commit, state}, keyword) {
    var idx = _.findIndex(state.keywords, k => k.text == keyword.text)
    if (idx != -1) {
      commit('ACTIVATE_KEYWORD', idx)
    }
  },
  removeKeyword ({commit, state}, keyword) {
    var idx = _.findIndex(state.keywords, k => k.text == keyword.text)
    if (idx != -1) {
      commit('DELETE_KEYWORD', keyword)
    }
  }
}

const mutations = {
  ADD_KEYWORD (state, keyword) {
    if (!state.keywords.filter(k => k.text == keyword.text).length) {
      state.keywords.push(keyword)
    }
  },
  DEACTIVATE_KEYWORD (state, idx) {
    state.keywords[idx].active = false
  },
  ACTIVATE_KEYWORD (state, idx) {
    state.keywords[idx].active = true
  },
  DELETE_KEYWORD (state, idx) {
    state.keywords.splice(idx, 1)
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
