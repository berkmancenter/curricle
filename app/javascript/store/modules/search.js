// Manipulation of search-related data

import _ from 'lodash'
import apolloClient from 'apollo'
import COURSES_SEARCH_QUERY from '../../graphql/CoursesSearch.gql'

import { transformSchedule } from 'lib/util'

const thisYear = (new Date()).getUTCFullYear()

/* NOTE: any search state that affects the search results needs to be
 * taught to serializeSearch() and deserializeSearch() */

const state = {
  // list of objects with { text, weight, applyTo, active }
  keywords: [],
  results: [],
  resultsPage: 1,
  resultsPerPage: 50,
  resultsMoreAvailable: false,
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
  ],
  searchTermStart: 'Spring',
  searchTermEnd: 'Spring',
  searchYearStart: thisYear,
  searchYearEnd: thisYear + 1,
  searchTermUseRange: false,
  sortBy: 'RELEVANCE',
  sortByOptions: [
    { text: 'Relevance', value: 'RELEVANCE' },
    { text: 'Title', value: 'TITLE' },
    { text: 'School', value: 'SCHOOL' },
    { text: 'Semester', value: 'SEMESTER' },
    { text: 'Department', value: 'DEPARTMENT' },
    { text: 'Course ID', value: 'COURSE_ID' }
  ],
  timeRanges: undefined
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
      commit('DELETE_KEYWORD', idx)
    }
  },
  runKeywordSearch ({commit, state, getters, dispatch}) {
    var kw = getters.activeKeywords.map(k => _.clone(k))
    _.forEach(kw, k => delete k.active)

    if (kw && kw.length) {
      commit('RESET_RESULTS_PAGE')

      dispatch(
        'runSearch',
        {
          keywords: kw,
          handler: response => {
            state.results = response
            state.resultsMoreAvailable = (response.length === state.resultsPerPage)
            state.searchComplete = true
          }
        })
    } else {
      state.results = []
    }
  },
  runKeywordSearchAgain ({commit, state, getters, dispatch}) {
    var kw = getters.activeKeywords.map(k => _.clone(k))
    _.forEach(kw, k => delete k.active)

    if (kw && kw.length) {
      commit('INCREMENT_RESULTS_PAGE')

      dispatch(
        'runSearch',
        {
          keywords: kw,
          handler: response => {
            state.results = state.results.concat(response)
            state.resultsMoreAvailable = (response.length === state.resultsPerPage)
          }
        })
    } else {
      state.results = []
    }
  },
  runSearch ({commit, state, getters, dispatch}, {keywords, ids, handler}) {
    var vars = {}

    vars.page = state.resultsPage
    vars.perPage = state.resultsPerPage
    vars.sortBy = state.sortBy

    vars.semesterRange = {
      start: {
        term_name: state.searchTermStart.toUpperCase(),
        term_year: state.searchYearStart
      }
    }

    if (state.searchTermUseRange) {
      vars.semesterRange.end = {
        term_name: state.searchTermEnd.toUpperCase(),
        term_year: state.searchYearEnd
      }
    }

    if (state.timeRanges) {
      const dayLkup = {
        Mon: 'MONDAY',
        Tue: 'TUESDAY',
        Wed: 'WEDNESDAY',
        Thu: 'THURSDAY',
        Fri: 'FRIDAY'
      }

      vars.timeRanges = []

      _.each(
        state.timeRanges,
        (v, k) => {
          if (dayLkup[k]) {
            vars.timeRanges.push({ day_name: dayLkup[k], time_start: v[0], time_end: v[1] })
          }
        }
      )
    }

    if (ids && ids.length) {
      vars.ids = ids
    } else if (keywords && keywords.length) {
      vars.deluxeKeywords = keywords
    } else {
      console.error('runSearch: param errors')
      return
    }

    var promise = apolloClient.query({
      query: COURSES_SEARCH_QUERY,
      variables: vars
    }).then(response => {
      // standard transforms
      var courses = _.map(
        response.data.courses,
        c => {
          var o = _.clone(c)
          o.schedule = transformSchedule(o)
          o.semester = o.term_name + ' ' + o.term_year

          // TODO: Get from data; random for now
          o.department_color = '#' + Math.floor((Math.random() * (999 - 599)) + 600)
          return o
        })

      // store in registry
      dispatch('courses/registerCourses', courses, { root: true })

      return courses
      // finally run any user hanlder
    })

    promise.then(handler)
  },
  changeSortBy ({commit, state, dispatch}, value) {
    if (state.sortBy !== value) {
      commit('SET_SORT_BY', value)
      dispatch('runKeywordSearch')
    }
  },
  setTimeRanges ({commit}, r) {
    commit('SET_TIME_RANGES', r)
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
  },
  SET_SEARCH_TERM_START (state, termName) {
    state.searchTermStart = termName
  },
  SET_SEARCH_YEAR_START (state, termYear) {
    state.searchYearStart = termYear
  },
  SET_SEARCH_TERM_USE_RANGE (state, useRange) {
    state.searchTermUseRange = useRange
  },
  SET_SEARCH_TERM_END (state, termName) {
    state.searchTermEnd = termName
  },
  SET_SEARCH_YEAR_END (state, termYear) {
    state.searchYearEnd = termYear
  },
  INCREMENT_RESULTS_PAGE (state) {
    state.resultsPage += 1
  },
  RESET_RESULTS_PAGE (state) {
    state.resultsPage = 1
  },
  SET_SORT_BY (state, value) {
    state.sortBy = value
  },
  SET_TIME_RANGES (state, r) {
    state.timeRanges = r
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
