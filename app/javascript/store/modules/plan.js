// Manipulation of plan-related data

import Vue from 'vue/dist/vue.esm'
import _ from 'lodash'
import { partitionCoursesByMeetingTime, sortedSemesters } from 'lib/util'

const state = {
  semester: '',
  filters: {},
  filterFieldMap: {
    department: 'classAcademicOrgDescription',
    semester: 'semester'
  },
  provisionalCourses: {},
  viewMode: 'list'
}

const getters = {
  filteredCourses (state, getters) {
    // per lodash docs, empty object is true for all
    return _.filter(getters.trayCourses, _.mapKeys(state.filters, (v, k) => {
      return state.filterFieldMap[k] || k
    }))
  },
  // this is to import the vuex user.trayCourses and use locally as dependent
  trayCourses (state, getters, rootState, rootGetters) {
    return rootGetters['user/trayCourses']
  },
  departmentsInTray (state, getters) {
    return _.uniq(getters.trayCourses.map(k => k.classAcademicOrgDescription).sort())
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
  trayCoursesBySemester (state, getters) {
    return _.groupBy(getters.trayCourses, 'semester')
  },
  sortedSemestersInSchedule (state, getters) {
    return sortedSemesters(_.keys(getters.scheduledCoursesBySemester))
  },
  sortedSemestersInTray (state, getters) {
    return sortedSemesters(getters.semestersInTray)
  },
  // Return a collection of courses that conflict with other courses
  // each course object has a list of days of the week where conflicts are present
  // and contains the meetingTime data for those conflicting courses
  scheduledCourseConflictsByDay (state, getters) {
    const schedule = getters.scheduledCoursesBySemester
    let courseConflicts = {}

    _.forEach(schedule, semester => {
      const semesterSchedule = partitionCoursesByMeetingTime(semester)

      _.forEach(semesterSchedule, (day, dayName) => {
        if (dayName === 'TBD') { return }

        _.forEach(day, course => {
          _.forEach(day, (comparisonCourse) => {
            if (course === comparisonCourse) {
              return
            }

            const courseStartTime = course.meetingTime[0]
            const courseEndTime = courseStartTime + course.meetingTime[1]
            const startTime = comparisonCourse.meetingTime[0]
            const endTime = startTime + comparisonCourse.meetingTime[1]

            if (
              (courseStartTime >= startTime && courseStartTime < endTime) ||
              (courseEndTime > startTime && courseEndTime <= endTime) ||
              (courseStartTime <= startTime && courseEndTime >= endTime)
            ) {
              const courseId = course.course.id

              if (courseId in courseConflicts) {
                if (dayName in courseConflicts[courseId]) {
                  courseConflicts[courseId][dayName].push(comparisonCourse.meetingTime)
                } else {
                  courseConflicts[courseId][dayName] = [comparisonCourse.meetingTime]
                }
              } else {
                courseConflicts[courseId] = { [dayName]: [comparisonCourse.meetingTime], meetingTime: course.meetingTime }
              }
            }
          })
        })
      })
    })

    return courseConflicts
  },
  // for a given course and day, return the number of conflicts and horizontal position
  courseConflictInfoForDay: (state, getters) => (courseId, dayName) => {
    const conflictsByDay = getters.scheduledCourseConflictsByDay

    if (!conflictsByDay || !(courseId in conflictsByDay) || !(dayName in conflictsByDay[courseId])) {
      return { conflictCount: 0, position: 0 }
    }

    // calculate position of course against its conflicts sorted by meeting start time, then duration, then course ID
    const courseMeetingTime = conflictsByDay[courseId].meetingTime
    const courseArray = conflictsByDay[courseId][dayName]
    const position = _.sortedIndexBy(courseArray, courseMeetingTime, (cmt) => { return [cmt[0], cmt[1], cmt[2]] })

    return {
      conflictCount: conflictsByDay[courseId][dayName].length,
      position: position
    }
  }
}

const actions = {
  selectView ({ commit }, view) {
    commit('SET_VIEW_MODE', view)
  },
  setFilter ({ commit }, filter) {
    commit('SET_FILTER', filter)
  },
  setSemester ({ commit }, semester) {
    commit('SET_SEMESTER', semester)
  },
  addProvisionalCourse ({ commit }, course) {
    commit('ADD_PROVISIONAL_COURSE', course)
  },
  removeProvisionalCourse ({ commit }, course) {
    commit('DEL_PROVISIONAL_COURSE', course)
  }
}

const mutations = {
  SET_FILTER (state, { name, value }) {
    if (value) {
      Vue.set(state.filters, name, value)
    } else {
      Vue.delete(state.filters, name)
    }
  },
  SET_SEMESTER (state, semester) {
    state.semester = semester
  },
  ADD_PROVISIONAL_COURSE (state, course) {
    if (course && course.id) {
      Vue.set(state.provisionalCourses, course.id, course)
    }
  },
  DEL_PROVISIONAL_COURSE (state, course) {
    if (course && course.id) {
      Vue.delete(state.provisionalCourses, course.id)
    }
  },
  SET_VIEW_MODE: (state, value) => {
    if (['list', 'week', 'semester'].includes(value)) {
      state.viewMode = value
    }
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
