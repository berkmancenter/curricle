// Manipulation of plan-related data

import _ from 'lodash'

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
  // returns all courses which are currently scheduled in the tray ()
  scheduledCourses (state, getters, rootState, rootGetters) {
    return rootGetters['user/scheduledCourses']
  },
  scheduledCoursesBySemester (state, getters) {
    return _.groupBy(getters.scheduledCourses, 'semester')
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
