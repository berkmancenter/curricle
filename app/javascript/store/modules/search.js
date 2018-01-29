// Manipulation of search-related data

import _ from 'lodash'
import { ApolloClient } from 'apollo-client'
import { createHttpLink } from 'apollo-link-http'
import { setContext } from 'apollo-link-context'
import { InMemoryCache } from 'apollo-cache-inmemory'
import gql from 'graphql-tag'

const httpLink = createHttpLink({
  uri: '/graphql'
})

const authLink = setContext((_, { headers }) => {
  const token = localStorage.getItem('curricle_api_token')

  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : null
    }
  }
})

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache()
})

function calcDuration (start, end) {
  if (!(start && end)) {
    return 0
  }
  var startPart = start.split(':')
  var endPart = end.split(':')

  var hours = endPart[0] - startPart[0]
  var mins = endPart[1] - startPart[1]

  return hours + Math.ceil(mins / 5) / 12
}

/* transform the core course data into the expected days structure for other times */
function transformSchedule (c) {
  if (c && c.course_meeting_patterns && c.course_meeting_patterns.length) {
    // We are currently only pulling the first non-null records here.
    // We will need to revisit this to support different meeting times on
    // different days

    var m = _.find(c.course_meeting_patterns, p => p.meeting_time_start_tod)

    if (!m) {
      return []
    }

    // NOTE: this structure is currently shared; might need to make clones of this in
    // the future, but is conceptually read-only data should be fine
    // for now.

    var courseMeetingInfo = [
      m.meeting_time_start_tod,
      m.meeting_time_end_tod,
      calcDuration('0:00', m.meeting_time_start_tod),
      calcDuration(m.meeting_time_start_tod, m.meeting_time_end_tod)
    ]

    return [
      m.meets_on_monday ? courseMeetingInfo : undefined,
      m.meets_on_tuesday ? courseMeetingInfo : undefined,
      m.meets_on_wednesday ? courseMeetingInfo : undefined,
      m.meets_on_thursday ? courseMeetingInfo : undefined,
      m.meets_on_friday ? courseMeetingInfo : undefined,
      m.meets_on_saturday ? courseMeetingInfo : undefined,
      m.meets_on_sunday ? courseMeetingInfo : undefined
    ]
  } else {
    // return empty array for no scheduled day/times
    return []
  }
}

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
  runKeywordSearch ({commit, state, getters, dispatch}) {
    var kw = getters.activeKeywords.map(k => _.clone(k))
    _.forEach(kw, k => delete k.active)

    if (kw && kw.length) {
      state.searchComplete = false

      dispatch(
        'runSearch',
        {
          keywords: kw,
          handler: response => {
            state.results = response
            state.searchComplete = true
          }
        })
    } else {
      state.results = []
    }
  },
  runSearch ({commit, state, getters, dispatch}, {keywords, ids, handler}) {
    var vars = {}
    var typespec, queryspec

    if (ids && ids.length) {
      vars.courseIds = ids
      typespec = '$courseIds: [Int]'
      queryspec = 'course_ids: $courseIds'
    } else if (keywords && keywords.length) {
      vars.deluxeKeywords = keywords
      typespec = '$deluxeKeywords: [DeluxeKeywordInput]'
      queryspec = 'deluxe_keywords: $deluxeKeywords'
    } else {
      console.error('runSearch: param errors')
      return
    }

    var promise = client.query({
      query: gql`
        query CourseSearch(${typespec}) {
          courses(${queryspec}) {
            academic_group
            academic_group_description
            catalog_number
            component
            course_description
            course_description_long
            external_course_id
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
            annotation {
              text
            }
          }
        }
      `,
      variables: vars
    }).then(response => {
      // standard transforms
      var courses = _.map(
        response.data.courses,
        c => {
          var o = _.clone(c)
          o.days = transformSchedule(o)
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
