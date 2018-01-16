// Manipulation of search-related data

const state = {
  // list of objects with { text, weight, applyTo, active }
  keywords: [],
  results: []
}

const getters = {
  activeKeywords: state => state.keywords.filter(kw => kw.active),
  inactiveKeywords: state => state.keywords.filter(kw => !kw.active),
}

const actions = {

}

const mutations = {
  
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
