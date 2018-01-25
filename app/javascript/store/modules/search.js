// Manipulation of search-related data

import _ from 'lodash'
import ApolloClient from 'apollo-client-preset'
import gql from 'graphql-tag'

const client = new ApolloClient()

const state = {
  // list of objects with { text, weight, applyTo, active }
  keywords: [],
  results: [],
  searchComplete: false,
  applyToOptions: [
    { text: 'Title', value: 'TITLE' },
    { text: 'Description', value: 'DESCRIPTION' },
    { text: 'Instructor', value: 'INSTRUCTOR' },
    { text: 'Readings', value: 'READINGS', disabled: true },
    { text: 'Course ID', value: 'COURSE_ID' }
  ],
  weightOptions: [
    { text: '1', value: 1 },
    { text: '2', value: 2 },
    { text: '3', value: 3 },
    { text: '4', value: 4 },
    { text: '5', value: 5 },
    { text: '6', value: 6 },
    { text: '7', value: 7 },
    { text: '8', value: 8 },
    { text: '9', value: 9 }
  ]
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
    var idx = _.findIndex(state.keywords, k => k.text === keyword.text)
    if (idx !== -1) {
      commit('DEACTIVATE_KEYWORD', idx)
    }
  },
  activateKeyword ({commit, state}, keyword) {
    var idx = _.findIndex(state.keywords, k => k.text === keyword.text)
    if (idx !== -1) {
      commit('ACTIVATE_KEYWORD', idx)
    }
  },
  removeKeyword ({commit, state}, keyword) {
    var idx = _.findIndex(state.keywords, k => k.text === keyword.text)
    if (idx !== -1) {
      commit('DELETE_KEYWORD', keyword)
    }
  },
  runSearch ({commit, state, getters, dispatch}) {
    var kw = getters.activeKeywords.map(k => _.clone(k))
    _.forEach(kw, k => delete k.active)

    if (kw && kw.length) {
      state.searchComplete = false

      // need to keep this structure in sync with the one in courses.js
      client.query({
        query: gql`
            query CourseSearch($deluxeKeywords: [DeluxeKeywordInput]) {
              courses(deluxe_keywords: $deluxeKeywords) {
                academic_group
                catalog_number
                component
                course_description_long
                id
                subject
                term_name
                term_year
                title
                units_maximum
                course_instructors {
                  display_name
                  id
                }
                course_meeting_patterns {
                  id
                  meeting_time_start_tod
                  meeting_time_end_tod
                  meets_on_monday
                  meets_on_tuesday
                  meets_on_wednesday
                  meets_on_thursday
                  meets_on_friday
                  meets_on_saturday
                  meets_on_sunday
                }
              }
            }
          `,
        variables: { deluxeKeywords: kw }
      })
        .then(response => {
          state.results = response.data.courses
          state.searchComplete = true
          dispatch('courses/registerCourses', response.data.courses, { root: true })
        })
    } else {
      state.results = []
    }
  }
}

const mutations = {
  ADD_KEYWORD (state, keyword) {
    if (!state.keywords.filter(k => k.text === keyword.text).length) {
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
