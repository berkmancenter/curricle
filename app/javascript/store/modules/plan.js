// Manipulation of plan-related data

import _ from 'lodash'

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

function extractSchedule (courses) {
  return _.map(
    _.filter(courses, e => e.meeting_with_tods !== null),
    c => {
      var m = c.meeting_with_tods
      var courseMeetingInfo = [
        m.meeting_time_start_tod,
        m.meeting_time_end_tod,
        calcDuration('0:00', m.meeting_time_start_tod),
        calcDuration(m.meeting_time_start_tod, m.meeting_time_end_tod)
      ]

      return {
        id: c.id,
        semester: c.term_name + ' ' + c.term_year,
        term_name: c.term_name,
        term_year: c.term_year,
        title: c.title,
        days: [
          m.meets_on_monday ? courseMeetingInfo : undefined,
          m.meets_on_tuesday ? courseMeetingInfo : undefined,
          m.meets_on_wednesday ? courseMeetingInfo : undefined,
          m.meets_on_thursday ? courseMeetingInfo : undefined,
          m.meets_on_friday ? courseMeetingInfo : undefined,
          m.meets_on_saturday ? courseMeetingInfo : undefined,
          m.meets_on_sunday ? courseMeetingInfo : undefined
        ]
      }
    }
  )
}

function sortedSemesters (sems) {
  const semOrder = ['Spring', 'Summer', 'Fall']

  if (!sems) return []
  return sems.sort((a, b) => {
    if (a === b) {
      return 0
    }

    var aPart = a.split(' ')
    var bPart = b.split(' ')

    if (aPart[1] !== bPart[1]) {
      return Math.sign(aPart[1] - bPart[1])
    }

    return Math.sign(semOrder.indexOf(aPart[0]) - semOrder.indexOf(bPart[0]))
  })
}

const state = {
  semester: '',
  filters: {},
  filterCategories: [
    {
      field: 'department',
      title: 'Department'
    },
    {
      field: 'semester',
      title: 'Semester'
    }
  ]
}

const getters = {
  filteredCourses (state, getters) {
    // per lodash docs, empty object is true for all
    return _.filter(getters.trayCourses, state.filters)
  },
  // this is to import the vuex user.trayCourses and use locally as dependent
  trayCourses (state, getters, rootState, rootGetters) {
    return rootGetters['user/trayCourses']
  },
  departmentsInTray (state, getters) {
    return _.uniq(getters.trayCourses.map(k => k.academic_group_description).sort())
  },
  semestersInTray (state, getters) {
    return _.uniq(getters.trayCourses.map(k => k.semester).sort())
  },
  eventData (state, getters) {
    return getters.trayCourses
      .filter(item => !!item.user_schedule[0].course_meeting_pattern_id)
      .map(item => {
        return {
          title: ' ',
          start: item.meeting_with_tods.meeting_time_start,
          end: item.meeting_with_tods.meeting_time_end,
          description: item.subject_description,
          course: item
        }
      })
  },
  // returns all courses which are currently scheduled in the tray ()
  scheduledCourses (state, getters, rootState, rootGetters) {
    return rootGetters['user/scheduledCourses']
  },
  scheduledCoursesBySemester (state, getters) {
    return _.groupBy(extractSchedule(getters.scheduledCourses), 'semester')
  },
  sortedSemestersInSchedule (state, getters) {
    return sortedSemesters(_.keys(getters.scheduledCoursesBySemester))
  },
  currentSchedule (state, getters) {
    return getters.scheduledCoursesBySemester[state.semester] || []
  },
  currentScheduleByDay (state, getters) {
    var days = []
    _.each(getters.currentSchedule, course => {
      var courseCopy = _.clone(course)
      delete courseCopy.days
      course.days.forEach((d, i) => {
        if (d) {
          var obj = _.clone(courseCopy)
          obj.day = d
          if (!days[i]) {
            days[i] = []
          }
          days[i].push(obj)
        }
      })
    })
    return days
  }
}

const actions = {
  setFilter ({commit}, filter) {
    commit('SET_FILTER', filter)
  },
  setSemester ({commit}, semester) {
    commit('SET_SEMESTER', semester)
  }
}

const mutations = {
  SET_FILTER (state, {name, value}) {
    if (value === '') {
      delete state.filters[name]
    } else {
      state.filters[name] = value
    }
  },
  SET_SEMESTER (state, semester) {
    state.semester = semester
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
